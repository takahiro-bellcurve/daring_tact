import os
import typing as t

from dotenv import load_dotenv
from slack_webhook import Slack


def fetch_env_vars() -> t.Dict[str, str or int or bool]:
    if os.getenv("APP_ENV") == "production":
        slack_webhook_url = os.getenv("SLACK_WEBHOOK_URL")
    elif os.getenv("APP_ENV") == "development":
        load_dotenv("../../.env")
        slack_webhook_url = os.getenv("SLACK_WEBHOOK_URL")
    else:
        raise Exception("APP_ENV not set")
    
    vars = {
        "slack_webhook_url": slack_webhook_url
    }
    return vars

def main(request):
    vars = fetch_env_vars()
    slack = Slack(url=vars["slack_webhook_url"])
    
    request_body = request.get_json()
    attachments = {
        "fallback": "Plan a vacation",
        "author_name": "Slack通知テストくん",
        "title": request_body["title"],
        "text": request_body["text"],
    }

    slack.post(text="Slack通知テストくんからのお知らせ",
        attachments = [attachments]
    )
    return "ok"
