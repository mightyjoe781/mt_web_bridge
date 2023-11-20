from flask import Flask
import queue
import time

app = Flask(__name__)

task_queue = queue.Queue()
cnt = 0

@app.route('/')
def hello_world():
    return "hello world"

@app.route('/put')
def producer():
    task_queue.put(f"{time.time()}-task-{cnt}")
    print(str(task_queue))
    return "Task put successfully"

@app.route('/consume')
def consumer():
    task = task_queue.get()
    print(f"{str(task)} completed")
    return task

if __name__ == "__main__":
    app.run()