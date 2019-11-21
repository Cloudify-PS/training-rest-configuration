import requests
import json

from cloudify import ctx

def call_add_card(id, title, content):
    payload = {
            'title': title,
            'content': content
        }
    add_action = requests.put(
        'http://localhost:5000/api/cards/{card_id}'.format(
            card_id=id),
            data=json.dumps(payload),
            headers={
                'Content-Type': 'application/json'
            }
    )
    ctx.logger.info(add_action.text)

    return add_action.status_code == 201



params = ctx.instance.runtime_properties['params']

for param in params:
    if param not in ('diff_params','old_params'):
        param_value = ctx.instance.runtime_properties['params'][param]
        call_add_card(param, param_value['title'],param_value['content'])
