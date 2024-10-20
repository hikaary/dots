import argparse
import os
import subprocess

import requests

# Глобальное сообщение с инструкциями
COMMIT_MESSAGE_PROMPT = """
Создайте сообщение коммита на русском языке на основе следующего diff:

```
{diff}
```

Сообщение коммита должно состоять из двух частей:

1. Заголовок (Title):
   - Краткое описание основных изменений
   - Не должен превышать 50 символов
   - Использовать глагол в повелительном наклонении (например, "добавить", "исправить", "обновить")

2. Детальное описание:
   - Каждый тип изменений на отдельной строке
   - Формат каждой строки: <тип>(область): <описание>
   - Быть информативным, но кратким
   - Использовать глаголы в прошедшем времени (например, "добавлено", "исправлено", "обновлено")
   - Каждая строка не должна превышать 72 символа в длину

Типы коммитов:
- feat: новая функциональность
- fix: исправление ошибки
- docs: изменения в документации
- style: изменения форматирования, отступов и т.д. (не влияющие на код)
- refactor: рефакторинг кода
- perf: улучшения производительности
- test: добавление или изменение тестов
- build: изменения в системе сборки или внешних зависимостях
- ci: изменения в конфигурации CI/CD
- chore: другие изменения, не затрагивающие код или тесты

Если в diff присутствуют изменения, относящиеся к нескольким типам, включите их все в детальное описание, каждый на отдельной строке.
Пожалуйста, создайте сообщение коммита, соответствующее этим критериям и основанное на предоставленном diff.

Формат ответа должен быть следующим:
<заголовок коммита>

<детальное описание>
"""


def get_api_key(api_type):
    if api_type == 'openai':
        return os.getenv('OPENAI_API_KEY')
    elif api_type == 'claude':
        return os.getenv('CLAUDE_API_KEY')
    else:
        raise ValueError(f'Неизвестный тип API: {api_type}')


def get_git_diff():
    result = subprocess.run(['git', 'diff', '--cached'], stdout=subprocess.PIPE)
    return result.stdout.decode('utf-8')


def generate_commit_message_claude(diff, api_key):
    headers = {
        'Content-Type': 'application/json',
        'x-api-key': api_key,
        'anthropic-version': '2023-06-01',
    }
    data = {
        'messages': [
            {
                'role': 'user',
                'content': COMMIT_MESSAGE_PROMPT.format(diff=diff),
            }
        ],
        'max_tokens': 3000,
        'model': 'claude-3-5-sonnet-20240620',
    }
    response = requests.post(
        'https://api.anthropic.com/v1/messages',
        proxies={'http': '127.0.0.1:1081', 'https': '127.0.0.1:1081'},
        headers=headers,
        json=data,
    )
    completion = response.json().get('content', [{}])[0].get('text', '').strip()
    return completion


def generate_commit_message_openai(diff, api_key):
    headers = {
        'Content-Type': 'application/json',
        'Authorization': f'Bearer {api_key}',
    }
    data = {
        'model': 'gpt-4o',
        'messages': [
            {
                'role': 'system',
                'content': 'Вы - помощник по генерации сообщений коммитов.',
            },
            {
                'role': 'user',
                'content': COMMIT_MESSAGE_PROMPT.format(diff=diff),
            },
        ],
        'max_tokens': 3000,
    }
    response = requests.post(
        'https://api.openai.com/v1/chat/completions',
        proxies={'http': '127.0.0.1:1081', 'https': '127.0.0.1:1081'},
        headers=headers,
        json=data,
    )
    response_json = response.json()
    return response_json['choices'][0]['message']['content'].strip()


def format_commit_message(message):
    lines = message.split('\n')
    title = lines[0].replace('TITLE: ', '')
    body = '\n'.join(lines[2:])  # Пропускаем пустую строку после TITLE
    return f'{title}\n\n{body}'


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Генератор сообщений коммитов')
    parser.add_argument(
        '--openai',
        action='store_true',
        help='Использовать OpenAI API вместо Claude',
    )
    args = parser.parse_args()

    diff = get_git_diff()
    if diff.strip() == '':
        print('Нет изменений для коммита.')
    else:
        if args.openai:
            api_key = get_api_key('openai')
            commit_message = generate_commit_message_openai(diff, api_key)
        else:
            api_key = get_api_key('claude')
            commit_message = generate_commit_message_claude(diff, api_key)

        formatted_message = format_commit_message(commit_message)
        print(formatted_message)
