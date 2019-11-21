import requests
import json

from cloudify import ctx


def call_edit_card(id, title, content):
    payload = {
            'title': title,
            'content': content
        }
    edit_action = requests.put(
        'http://localhost:5000/api/cards/{card_id}/edit'.format(
            card_id=id),
            data=json.dumps(payload),
            headers={
                'Content-Type': 'application/json'
            }
    )
    ctx.logger.info(edit_action.text)


    return edit_action.status_code == 201



params = ctx.instance.runtime_properties['params']

for param in params:
    if param not in ('diff_params','old_params'):
        param_value = ctx.instance.runtime_properties['params'][param]
        call_edit_card(param, param_value['title'], param_value['content'])
