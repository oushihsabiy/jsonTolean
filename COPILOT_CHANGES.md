# Copilot Change Log

用于记录每次由 Copilot 进行的代码修改细节。后续每次修改代码后，都会先更新本文件，再执行 git add/commit/push。

## 2026-03-25

### 变更任务
- 新建 `jsonTolean_informal` 项目，基于 `jsonTolean-main` 构建，去除 `concise_to_lean` 中间步骤。

### 具体修改内容

#### 新建文件
- `main.py`：简化后的 pipeline 入口，仅包含 2 步（preprocess → jsonTolean），移除了 concise_to_lean 相关的所有导入、参数和逻辑（`--skip-concise` 标志、`run_concise_to_lean()` 函数、`think_workers` 线程池等）。
- `src/helpers.py`：从原 `concise_to_lean.py` 中提取的公共工具函数（`load_config`、`read_json`、`write_json`、`iter_exercise_objects`、`is_exercise_object`、`require_str`、`find_config_json`、流式 LLM 辅助函数等），作为独立模块供 `jsonTolean.py` 和 `main.py` 使用。
- `src/jsonTolean.py`：JSON → Lean 转换模块，改为从 `helpers.py` 导入（不再依赖 `concise_to_lean.py`）。
- `src/prompt/json_to_lean.md`：修改后的 prompt，适配非结构化（informal）输入。新增指引要求 LLM 自行从原始自然语言文本中识别 definitions、hypotheses 和 goals，而非依赖预处理后的 Definition/Hypothesis/Goal 标签。
- `README.md`：项目说明文档，包含与 `jsonTolean-main` 的对比表。
- `COPILOT_CHANGES.md`：变更记录文件。
- `config.json`、`config.example.json`、`settings.json`：配置文件（与原项目一致）。
- `lakefile.toml`、`lean-toolchain`、`lake-manifest.json`、`output_lean.lean`、`LICENSE`：Lean 项目配置（与原项目一致）。

#### 移除的内容（相比 jsonTolean-main）
- `src/stdjson/concise_to_lean.py`：不再需要。
- `src/prompt/concise_to_lean.md`：不再需要。
- `main.py` 中的 `--skip-concise` 参数和 `run_concise_to_lean()` 函数。
- `main.py` 中的并发 `think_workers` 线程池逻辑（仅用于 concise_to_lean 步骤）。

### 影响范围
- 新项目，不影响 `jsonTolean-main` 的现有代码。
- pipeline 从 3 步简化为 2 步：preprocess → jsonTolean。
