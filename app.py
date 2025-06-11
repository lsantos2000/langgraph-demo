from langgraph.prebuilt import create_react_agent
from langchain_openai import ChatOpenAI
from dotenv import load_dotenv
import os

# Load environment variables
load_dotenv()

# Initialize the ChatOpenAI model
llm = ChatOpenAI(
    model_name="gpt-3.5-turbo",
    openai_api_key=os.getenv("OPENAI_API_KEY")
)

# Create a simple agent
def get_weather(city: str) -> str:
    """Get weather for a given city."""
    return f"It's always sunny in {city}!"

agent = create_react_agent(
    model=llm,
    tools=[get_weather],
    prompt="You are a helpful assistant"
)

if __name__ == "__main__":
    print("Type 'quit' to exit the program")
    
    while True:
        question = input("\nEnter your question (or type 'quit' to exit): ")
        if question.lower() == 'quit':
            print("\nGoodbye!")
            break
            
        result = agent.invoke({"messages": [{"role": "user", "content": question}]})
        print("\nAnswer:", result)
