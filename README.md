# LangGraph Demo Application

A simple demo application using LangGraph and LangChain to create a basic conversational AI, plus a jmeter suite.

## Setup

1. Create a `.env` file in the project root and add your OpenAI API key:
```
OPENAI_API_KEY=your_api_key_here
```

2. Install dependencies:
```bash
pip install -r requirements.txt
```

3. Run the application:
```bash
python app.py
```

## Usage

Run the application and enter your question when prompted. The application will use LangGraph and OpenAI's GPT-3.5-turbo model to generate a response.
