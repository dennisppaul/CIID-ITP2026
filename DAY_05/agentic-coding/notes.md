---
hedgedoc: https://notepad.hfk-bremen.de/s/vaXZnrjAy
tags: ciid2026, itp1016
---
# Agentic Creative Coding Workshop

> "It is important for a student to do things that are difficult and that do not come easy!", Dr Daniel Amen ( psychiatrist )

---

1. **Framing** the term & the debate
2. **What We Mean by "AI"** weighted networks → trained models
3. **The Model Landscape** popular LLMs
4. **Chat Bots & Coding Agents**
5. **Memory, Context & Tokens**
6. **Working with Agents** incl. ground rules & security
7. **A Method for Agentic Coding**
8. **Workshop & Discussion**
9. **Open Questions** critical perspectives
10. **Appendix** glossary, references

---

# 01 Framing

the term & the debate

---

# Agentic Creative Coding

introduce the term *Agentic Creative Coding*

---

# "If something is easy and everyone can do it, it has little value"

<!-- TODO: add attribution for this quote -->

what does this mean in the age of *agentic coding*?

- what can you add that is *not* easy?
- do you even have to?

---

# The Chinese Poem Test

> "ask the coding agent to write you a chinese poem", Jose 

- how do you **evaluate** it?
- what does this tell you about evaluating *code*?

*( we will come back to this in section 07 )*

---

# Out of the Shadow, Into the Light

let us pull the coding agents out of the shadow into the light

- let's *use* it
- let's *discuss* it!

*( ground rules for using agents in this workshop follow in section 06, once we know what agents, CLIs and plan mode are )*

---

# 02 What We Mean by "AI"

but let's take a step back and look at what is actually happening ...

---

# Weighted Networks → Trained Models

at the core of most *Artificial Intelligence* (AI) these days, there is actually a weighted network i.e a *trained model*.

a brain can also be thought of as a *weighted network* running on different hardware.

see [3Blue1Brown: Neural Networks](https://www.3blue1brown.com/?topic=neural-networks) for a more complete explanation.

---

# Training Models

*training* refers to the process of using a huge chunk of data ( e.g texts from books, websites, code repositories, forums, etcetera ) to modify the weights in the network.

- the training process has evolved a lot over the last years
- it is **extremely** resource consuming: intense amounts of data, energy, and time
- once a model is trained it does not change anymore

---

# Trained Models are Frozen Brains

a trained model is like a *brain frozen in time*.

it does not change unless it undergoes the costly training process again ( ← this is important to keep in mind ).

a lighter-weight update called *fine-tuning* allows targeted adjustments without full retraining but it is still a deliberate, separate process.

---

# Large Language Models

models trained with large amounts of *language* data ( texts from books, newspapers, forums, etcetera ) are referred to as a *Large Language Model* (LLM).

- an LLM is a system that is good at *predicting the next token* ( roughly: the next word or word fragment more on tokens in section 05 )
- other models were trained on other types of data, e.g image data
- models that handle different types of data are *multi-modal* ( e.g text, images, audio )

---

# Using Models → Generative AI

once a model is trained it can be used on or with data similar to that which it was trained with.

- some systems generate text based on an LLM
- others generate images typically based on a *Diffusion Model* (DM); a *Generative Adversarial Network* (GAN) was an earlier approach, less common today

AI systems that generate text, images or audio are often referred to as **Generative AI**.

---

# Training ↔ Inference

the process by which an AI model makes predictions or generates outputs is called *inference*.

**in summary:** first a model is *trained* with data, then it uses *inference* to predict, generate or classify similar data.

in the context of *Creative Coding* we usually deal with LLMs used for inference.

---

# 03 The Model Landscape

---

# Popular LLMs ( as of November 2026 )

model names and rankings change every few weeks think in *families* and *types*, not version numbers.

**closed / proprietary frontier models**

- **Anthropic Claude** ( Opus, Sonnet, Haiku; Fable ) :: strong at coding and agentic work, long contexts
- **OpenAI GPT** ( GPT-6.x ) :: all-purpose, consistent performer
- **Google Gemini** ( 3.x Pro / Flash ) :: multimodal; Flash variants fast and cost-efficient
- **xAI Grok** :: competitive reasoning model

**open-weights models** ( download and run yourself )

- **DeepSeek** ( V4 ) :: technical reasoning, agentic coding, cost-effective
- **Qwen** ( Alibaba ) :: multilingual, many sizes from tiny to huge
- **Kimi** ( Moonshot ), **GLM** ( Z.ai ) :: strong recent open contenders
- **Mistral** :: European, efficiency-focused
- **Llama** ( Meta ) :: popular open-weights family, but no new open release since Llama 4 ( April 2025 )

check a live leaderboard ( e.g LMArena ) before trusting any ranking.

---

# Open Source vs Open Weights

"open" means different things:

- **open weights** :: the trained parameters are downloadable you can run, fine-tune and self-host the model
- **open source** ( in the strict sense ) :: would also include training data and training code almost no frontier model releases these
- licenses differ too: some are permissive ( MIT, Apache 2.0 ), others are custom licenses with restrictions ( e.g Llama )

most "open" LLMs are *open weights*, not open source.

---

# Notes on LLMs

- some LLMs work better with *agents* than others
- most LLMs have a specific target
- some are highly specialized or optimized for a certain task
- the size of a model is often described in *parameters*

---

# 04 Chat Bots & Coding Agents

---

# Chat Bots and Coding Agents

these days we mostly interact with *chat bots* or *coding agents*. there are many other AI applications but these two are the most common ones.

---

# Chat Bot

a chat bot is a system that can communicate in human language ( and often also images ) with a counterpart ( often a human ).

- it maintains conversation history this is the *context window*
- but it has limits

---

# Coding Agent

a coding agent is basically a chat bot that can use *tools* ( often shell commands ):

- read/write files
- run scripts
- up-/download files
- read websites

it can reason, set up test environments, and work on complex tasks for extended periods of time.

---

# Quick Demo

before more theory let's watch an agent work:

- start a coding agent in an empty project folder
- ask it to create a small sketch ( e.g bouncing circles )
- watch it: read → plan → write files → run → fix

*( ~5 minutes, live )*

---

# 05 Memory, Context & Tokens

---

# The Memory Dilemma

interaction with a *pure* LLM ( i.e no conversation history ):

```text
human: hej my name is dennis.
qwen3: Hej Dennis! Nice to meet you.
       How can I help you today?
human: how do you spell my name?
qwen3: I don't know your name yet!
       Feel free to tell me, and I'll be happy
       to help you spell it.
human: i just told you my name :(
qwen3: Oh no, I'm really sorry to hear that! I
       wish I could remember our past conversations,
       but I don't actually have the ability to
       store information between different chats.
```

---

# Why Does This Matter?

AI models are *frozen brains*.

- you could say they are *only* long term memory
- the model itself has *no* short term memory of its own nothing from your conversation is stored in its weights
- everything it knows is trained into its weights from static data

---

# But Why Can I Have a Conversation With My Chat Bot Then?

a system like a chat bot ( or a coding agent ) *emulates* short-term memory:

it literally re-processes every step of the conversation each time you ask a follow up.

when you ask **question 13**, the system processes all previous questions **plus** question 13 to produce an answer.

---

# Managing the Context Window

the size of this emulated short-term memory is the *context window*. managing it is a major task when working with chat bots and coding agents.

- **long contexts get worse, not just more expensive** the more is in the context, the more likely the model loses track of details or earlier instructions ( sometimes called *context rot* )
- **compacting conversations** occasionally ask the LLM to summarize the conversation into a smaller version
- **memory files** write ( or have the LLM write ) text files the agent can read back: documentations, specifications, plans
- **new task, new session** start a new session for a new task; context is rebuilt, but the context window is fresh and focused

---

# Tokens

*tokens* are the smallest units that models can process.

- tokens can be individual characters, sub or whole words, and special symbols
- context window size is measured in tokens
- the more tokens an LLM processes, the more resources it consumes
- many services have input and output token limits

⇒ it is worth learning strategies to **save tokens**.

---

# Saving Tokens

- all strategies for managing the context window also help reduce token usage
- **caveman** :: use *very* minimal, simplified language ( akin to how we imagine cavemen would speak ); there is a plugin for some coding agents

---

# 06 Working with Agents

---

# Popular Coding Agents

- [OpenCode](https://opencode.ai/) :: good middle ground. works out of the box. paid and free tiers **recommended**
- [Pi](https://pi.dev/) :: very raw and lean. harder to set up
- [Claude Code](https://claude.com/product/claude-code) :: works very well. costs money and is proprietary

see [The AI Coding Agents Protocol](https://notepad.hfk-bremen.de/UlvdUYckQGS35XGchR0qBA) :: collection of interesting facts + terms about coding agents

---

# The Harness

these systems are often referred to as a *harness*. they orchestrate one or more agents to perform ( mostly, but not limited to coding ) tasks.

a *harness* is a framework or application that orchestrates an LLM agent, managing the loop between **reasoning → tool execution → feedback**.

harnesses are often terminal-based or embedded in IDEs.

---

# System Prompt

the text sent to a model is called a *prompt*. in most AI applications an extra chunk of text is added to *every* conversation: the *system prompt*.

- content and size of system prompts are often a point of discussion
- some are quite voluminous ( see `opencode-prompts-raw.md` )
- the system prompt is set by the harness as a user you usually don't edit it directly

> everyone is begging for compliance and alignment

read a few system prompts: they are full of capitalized pleas ( "IMPORTANT", "NEVER", "ALWAYS" ) vendors literally *beg* their models to behave.

---

# Memory Files :: `AGENTS.md`

it is common to add a project-level set of instructions in a single file often called `AGENTS.md` ( in *Claude Code* also `CLAUDE.md` ), located in the top-level folder of your project. the agent reads it at session start.

this is *your* layer of instructions added on top of the harness's system prompt.

- experiment with creating and modifying `AGENTS.md` files you can even ask the agent to create or improve them for you
- may contain *conventions*, *dependencies*, *project structure*, *preferences*, *plans*, etcetera
- used to save context that would otherwise be lost between sessions
- very common: ask the LLM to summarize the current session into a file

*( FYI: on macOS, Claude Code stores internal plans in `~/.claude/plans/` )*

---

# Plan Mode → Build Mode

- **plan mode** :: research, design, and think before coding. do not make edits
- **build mode** :: implement once the plan is approved. modify and generate files

some recommend to *always* plan a task first and only switch to build mode when the plan is properly developed.

---

# Eyes and Ears

agents try very hard to get things right … but they don't always. instruct an agent to **evaluate** whatever it produces.

most models today are multi-modal and *can* look at images but an agent can't see your *running sketch* unless you give it a way to:

- tell the agent to use `saveFrame()` to capture the screen and enable a visual feedback loop: **generate → inspect → adjust**
- ask the agent to create tests, and only finish when all tests pass

---

# Use Git

agents sometimes mess things up … hard. the best measure is to use `git` to revert changes or errors made by the agent.

- `git diff` shows you the changes made by the agent
- `git status` shows you the files changed by the agent

---

# Security

a coding agent runs commands on *your* machine. treat it accordingly.

- **permissions** :: know your harness's approval modes; don't auto-approve everything
- **prompt injection** :: websites, files or repos the agent reads can contain hidden instructions that hijack it
- **secrets** :: never paste API keys or passwords into prompts; keep them out of files the agent reads
- **scope** :: run agents inside a project folder, not your home directory

---

# Local Models

you don't have to send your code to a cloud service.

- open-weights models can run on your own machine ( e.g via [Ollama](https://ollama.com/) or [llama.cpp](https://github.com/ggml-org/llama.cpp) )
- coding agents like OpenCode can be pointed at a local model
- **pros** :: privacy, no per-token costs, works offline
- **cons** :: smaller models, slower, weaker at agentic tasks than frontier models

---

# Ground Rules

- if you choose to use AI, do it *properly*:
  - use coding agents, not chat bots
  - plan together with the LLM ( e.g `/grill-me` )
  - always try to understand the bigger picture
- we will not control you … this is also an exercise in discipline, willpower and self-control
- use the **CLI** … if you use coding agents, use them properly ( like a pro )
- use the coding agent itself through *prompts* to transition from co-teacher to programming tool

---

# 07 A Method for Agentic Coding

inspired by [Stop Prompting Claude. Use Karpathy's Method Instead.](https://youtu.be/7zZy1QTvokM)

---

# The Spec is the Bridge

the spec is the bridge between:

- your **taste** and **world knowledge** ←
- → the coding agent's **engineering skills**

**results need to be measurable.**

---

# Agile, Not Waterfall

develop in **small steps**.

iterate with the agent instead of defining one giant up-front plan and hoping it works.

---

# Verifiability

AI is good at what can be *checked*.

- if you can verify an outcome ( tests pass, the frame looks right, the sound plays ), the agent can iterate towards it
- if you can't, you're trusting blindly
- remember **the chinese poem test**: you can't evaluate a poem in a language you can't read and you can't evaluate code you don't understand

⇒ make outcomes *measurable* if you want to work with AI productively.

---

# Ghosts, Not Animals

Karpathy: LLMs are not like animals.

- animals are shaped by evolution and lived experience
- LLMs are *summoned ghosts* shaped by imitating human-written data
- they can be brilliant and strangely broken at the same time

⇒ don't expect animal ( or human ) intuitions to apply.

---

# The Environment

set up the agent's working environment:

- `AGENTS.md`
- skills

a well-prepared environment is half the work.

---

# Discussion Prompts

- "if something is easy and everyone can do it, it has little value" where does that leave us?
- the chinese poem test :: how do you evaluate the agent's output?
- how do you transition the coding agent from *co-teacher* to *programming tool*?

---

# 09 Open Questions

critical perspectives

---

# Learning Hygiene

- when does the agent help you learn, and when does it replace learning?
- *deskilling* :: what skills do you lose if you never write the code yourself?
- Sennett, *The Craftsman*: skill grows through slow, repeated practice and resistance what happens to craft when the resistance disappears?

---

# Authorship & Ownership

- "who owns the code?" you, the vendor, the authors of the training data?
- "does it feel like your program/work?"
- the training data was written by people who were mostly not asked

---

# Trust & Automation Bias

- *automation bias* :: we tend to trust machine output more than we should
- agents sound confident even when wrong
- what does a healthy level of distrust look like?

---

# Cost, Data & Power

- **energy & resources** :: training and inference consume large amounts of energy, water and hardware
- **data policies** :: where does your code / your prompts go? who can read or train on it?
- **security** :: see section 06
- **dependency** :: a few companies control the frontier models what does that mean for an art school?

---

# Appendix

---

# Glossary ( 1/2 )

- **AI** :: Artificial Intelligence
- **LLM** :: Large Language Model
- **GAN** :: Generative Adversarial Network
- **DM** :: Diffusion Model
- **training** :: teaching a model patterns from data from scratch
- **fine-tuning** :: adapting a pre-trained model to a specific task or domain
- **inference** :: running a trained model to generate output
- **prompt** :: input text that guides an LLM's response
- **chat bot** :: conversational interface for interacting with an LLM
- **coding agent** :: LLM agent that writes, executes, and iterates on code autonomously
- **open weights** :: model parameters published for download; training data and code usually not included

---

# Glossary ( 2/2 )

- **context window** :: maximum tokens an LLM can process in a single request
- **tokens** :: atomic units ( words, subwords, symbols ) that LLMs process
- **parameters** :: weights and biases in a neural network learned during training; larger models have more parameters
- **harness** :: framework that orchestrates an LLM agent, managing the loop between reasoning, tool execution, and feedback
- **system prompt** :: high-level instructions defining an LLM's behavior, tone, and capabilities
- **multi-modal model** :: can simultaneously process and understand various data formats ( modalities ) such as text, images, audio, video, and code
- **prompt injection** :: hidden instructions in content an agent reads that try to take over its behavior
- **clanker** :: slang ( originally from *Star Wars* ) for robots and AI; used pejoratively for AI systems and their output
- **automation bias** :: the tendency to over-trust output from automated systems, even when it is wrong

---

# References

- [Stop Prompting Claude. Use Karpathy's Method Instead.](https://youtu.be/7zZy1QTvokM)
- [3Blue1Brown: Neural Networks](https://www.3blue1brown.com/?topic=neural-networks)
- [The AI Coding Agents Protocol](https://notepad.hfk-bremen.de/UlvdUYckQGS35XGchR0qBA)
- [OpenCode](https://opencode.ai/) · [Pi](https://pi.dev/) · [Claude Code](https://claude.com/product/claude-code)
- [Ollama](https://ollama.com/) · [llama.cpp](https://github.com/ggml-org/llama.cpp)
- Richard Sennett, *The Craftsman* ( 2008 )
