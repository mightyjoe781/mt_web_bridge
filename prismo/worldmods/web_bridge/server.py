from flask import Flask, request
import queue

app = Flask(__name__)

task_queue = queue.Queue()
response_queue = queue.Queue()

@app.route('/')
def hello_world():
    return "Status: Up"

@app.route('/api/cmd', methods=["POST"])
def producer():
    data = request.get_json(force=True)
    print(data)
    task_queue.put(data)
    while(True):
        try:
            item = response_queue.get(timeout=35)
            if item is None:
                break
            if item[0]["id"] == data[0]["id"]:
                return {
                    "status": "success",
                    "task": item
                }
            else:
                task_queue.put(item)
        except queue.Empty:
            break
        except Exception as e:
            return {
                "status": "failed",
                "error": e
            }
    return {
        "status": "failed",
        "error": "web_bridge_mod timed out"
    }

# consumer polls this end point
@app.route('/api/bridge')
def polling_consumer():
    try:
        task = task_queue.get(timeout=2)
        if task is None:
            return [{ "type":"heartbeat" }]
        return task
    except queue.Empty:
        return [{ "type":"heartbeat" }]
    except Exception as e:
        return [{"type": "exception", "error":str(e)}]

# response from consumer
@app.route('/api/bridge', methods=["POST"])
def consumer_reply():
    # handle assuming string
    data = request.get_json(force=True)
    # this should be sent to original request that enqueued the task
    if data[0]["type"] != "heartbeat":
        print(data)
        response_queue.put(data)

    return data

if __name__ == "__main__":
    app.run()