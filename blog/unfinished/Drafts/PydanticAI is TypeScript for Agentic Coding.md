I'd be stunned if the one of the words added to the dictionary this year were not 'agentic'. It is a word that rolls off the tongue so well and will likely be tied to everything with the explosion of AI agent driven workloads we are seeing hit the media and markets.

When PydanticAI emerged in my numerous feeds recently I knew I had to check it out. You see, using pydantic with Python is akin to using TypeScript with NodeJS. Strongly typed Python is the foundation of some other excellent libraries you may have heard of. [FastAPI](https://fastapi.tiangolo.com/) is the wildly popular OpenAPI compliant API framework that uses pydantic to great effect. 

[PydanticAI]https://ai.pydantic.dev/ is billed as ".. a Python agent framework designed to make it less painful to build production grade applications with Generative AI.". I'm new to agentic programming but not to Python or these tools so it should be a natural fit.

---

## Scaffolding

Lets scaffold a new project using another AI tool I've been digging quite a bit called [WindSurf](). This has a feature called 'Cascade' that can be used to do things like starting new projects. Here is the prompt I'm going to try first. You know, to push the limits as much as possible :)

```prompt
Create a new Python microservice project named localagent that uses a virtual environment and the uv package manager. This project should include a taskfile.yml manifest with appropriate tasks to build the virtual environment, install python libraries into it, build, test, and deploy the application. The app itself uses the pydantic and pydantic-ai libraries and is able to be launched within uvicorn as a FastAPI server or run as a cli via the typer library. Finally, this should also include a web front end that uses webassembly to run a separate app that can interface with the running FastAPI server.
```

It got some bits right but started failing at the `uv` commands. I went ahead and setup a local `.mise.toml` file with the following contents

```toml
[tools]
task = 'latest'
uv = "latest"
python = '3.13.1'
```

I then ran `mise install` and manually ran this to setup the venv and libraries

```bash
uv venv && uv pip install pydantic pydantic-ai fastapi uvicorn typer
source .venv/bin/activate
```

I then made some taskfile.yml fixes, added a `pyproject.toml` with required packages and added some other project files I like to see and added in a local git ignored `.SECRETS.env` file that gets sourced in only via task.

> **API Key** <-- You will need one. I opted for grabbing a [Google Gemini](https://aistudio.google.com/app/apikey) one this time around.

```yaml

```
```

## Links

- [PynamoDB](https://github.com/pynamodb/PynamoDB)
- [pydantic](https://github.com/pydantic/pydantic)
- [PydanticAI](https://ai.pydantic.dev/)
- [FastAPI](https://fastapi.tiangolo.com/)