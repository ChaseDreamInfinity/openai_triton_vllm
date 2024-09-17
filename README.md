# openai_trtllm - OpenAI-compatible API for TensorRT-LLM

Provide an OpenAI-compatible API for [vLLM](https://github.com/vllm-project/vllm)
and [NVIDIA Triton Inference Server](https://github.com/triton-inference-server/tensorrtllm_backend), which allows you
to integrate with [langchain](https://github.com/langchain-ai/langchain)

## Get started

### Prerequisites

Remember to include the dependencies when cloning to build the project.

```bash
git clone --recursive https://github.com/ChaseDreamInfinity/openai_triton_vllm
```

### Build locally

Make sure you have [Rust](https://www.rust-lang.org/tools/install) installed.

```bash
cargo run --release
```

The executable arguments can be set from environment variables (prefixed by OPENAI_TRTLLM_) or command line:

**Notice: `openai_trtllm` communicate with `triton` over gRPC, so the `--triton-endpoint` should be the gRPC port.**

```bash
./target/release/openai_trtllm --help
Usage: openai_trtllm [OPTIONS]

Options:
  -H, --host <HOST>
          Host to bind to [default: 0.0.0.0]
  -p, --port <PORT>
          Port to bind to [default: 3000]
  -t, --triton-endpoint <TRITON_ENDPOINT>
          Triton gRPC endpoint [default: http://localhost:8001]
  -o, --otlp-endpoint <OTLP_ENDPOINT>
          Endpoint of OpenTelemetry collector
      --history-template <HISTORY_TEMPLATE>
          Template for converting OpenAI message history to prompt
      --history-template-file <HISTORY_TEMPLATE_FILE>
          File containing the history template string
      --api-key <API_KEY>
          Api Key to access the server
  -h, --help
          Print help
```

### Build with Docker

Make sure you have [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/)
installed.

```bash
docker build -t openai-triton-vllm -f openai_triton_vllm.Dockerfile .
```

The execution command for llama3 template in the docker container,

```bash
/app/bin/openai_trtllm --history-template-file /app/templates/history_template_llama3.liquid
```

## Chat template

`openai_trtllm` support custom history templates to convert message history to prompt for chat models. The template
engine used here is [liquid](https://shopify.github.io/liquid/). Follow the syntax to create your own template.

For examples of history templates, see the [templates](templates) folder.

Here's an example of llama3:

```
{% for item in items -%}
<|start_header_id|>{{ item.identity }}<|end_header_id|>
{{ item.content }}<|eot_id|>
{% endfor -%}
<|start_header_id|>assistant<|end_header_id|>
```

## References

- [cria](https://github.com/AmineDiro/cria)
- [openai_trtllm](https://github.com/npuichigo/openai_trtllm)
