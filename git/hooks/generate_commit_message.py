import os
import subprocess

import requests


def get_api_key():
    home = os.path.expanduser('~')
    api_key_path = os.path.join(home, 'anthropic_api_key.txt')
    with open(api_key_path, 'r') as f:
        return f.read().strip()


API_KEY = get_api_key()


def get_git_diff():
    result = subprocess.run(['git', 'diff', '--cached'], stdout=subprocess.PIPE)
    return result.stdout.decode('utf-8')


def generate_commit_message(diff):
    headers = {
        'Content-Type': 'application/json',
        'x-api-key': API_KEY,
        'anthropic-version': '2023-06-01',
    }
    message = f"""
    Сгенерируй сообщение коммита на русском языке с учетом следующих требований:

    - Заголовок до 50 символов, кратко описывающий изменения.
    - После заголовка пустая строка и более подробное описание.
    - Пиши кратко, используя неформальный тон.
    - Перечисли существенные изменения, избегая лишних деталей.
    - Не используй конкретные имена функций, классов или файлов из кода.
    - Не используй фразы типа "этот коммит", "это изменение" и т.д.
    - В ответе включай только сам текст коммита.
    - Подробное описание не должно описывать для чего были сделаны изменения.

    Вот дифф изменений:

    {diff}
    """
    data = {
        'messages': [
            {
                'role': 'user',
                'content': message,
            }
        ],
        'max_tokens': 300,
        'model': 'claude-3-5-sonnet-20240620',
    }
    response = requests.post(
        'https://api.anthropic.com/v1/messages',
        proxies={'http': '127.0.0.1:1081', 'https': '127.0.0.1:1081'},
        headers=headers,
        json=data,
    )
    completion = response.json().get('content', [1])[0].get('text', '').strip()
    return completion


if __name__ == '__main__':
    diff = get_git_diff()
    if diff.strip() == '':
        subprocess.run(['echo', 'Нет изменений для коммита.'])
    else:
        commit_message = generate_commit_message(diff)
        subprocess.run(['echo', commit_message])
