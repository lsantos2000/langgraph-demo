import langgraph
import inspect
import sys

print("LangGraph package location:", sys.modules['langgraph'].__file__)
print("\nAvailable modules:")
for name, obj in inspect.getmembers(langgraph):
    if inspect.ismodule(obj):
        print(f"- {name}")
