# brain_unify

**One capability bit from GBT V8, packaged standalone.** No. 114 of 341,
`llm` domain (LLM).

<p>
<img alt="python" src="https://img.shields.io/badge/python-3.9%2B-blue">
<img alt="license" src="https://img.shields.io/badge/license-MIT-green">
<img alt="deps" src="https://img.shields.io/badge/runtime%20dependencies-0-brightgreen">
</p>

> 大脑执行层·五维合一：一次跑完 route → execute → verify → health（**是顺序串链，数据顺着走**：route 的 best.kind 喂给 execute，chain 字典逐步累积）。🔴 2026-09-22 更正：这里原先写着「**星形**，unify 直接分别调四维，**不是**串链，那三条边在源码里查不到」—— **那句是错的**，已实测推翻：能力位 `brain_unify` 由 `api.py:313` 直接调 `brain_exec.unify()`，而该函数 **405/419/423/428 行**就是那三条边（route→execute→verify→health），`tests/test_framework.py:1209 test_brain_unify_chain` 也一直在测它。⇒ **别再把「自报是话术」用在这个位上**。唯一真实的那半条限定：`execute()` 只在**没给 kind** 时才会自己再调一次 route（`brain_exec.py:259`），而 unify 一定把 kind 传下去 ⇒ 不会双路由。⚠️ 口径补一句（2026-09-22 第二次独立复核后加，免得再来一轮争论）：**叫它「星形」也不算错** —— 从**调用图**看确实是 unify 这一个中枢分别调四维；错的只有原先那句「**那三条边在源码里查不到**」（它们在 405/419/423/428 行）。**串链说的是执行顺序与数据流，星形说的是调用图，两个层次，别互相否掉。**

That description is copied verbatim from the registry. `tests/test_spec.py` pins it,
so documentation drift fails the build instead of shipping quietly.

## What this package actually is

It is the **contract** for one capability: its name, its parameters, the values it
accepts, and whether it can change state that cannot be restored. It is not the
implementation — that lives in the runtime this bit was extracted from.

So `run()` goes through a narrow `Backend` protocol, and the default backend is a
stub that **says so**:

```
status="validated"   backend="stub"   data={"executed": false}
```

Never `status="ok"`. A stub that reports success is worse than no stub, because the
caller stops looking for the real thing.

## Install

```bash
git clone https://github.com/gbtweilai-star/gbt-brain-unify.git
cd gbt-brain-unify
python -m pip install -e ".[dev]"
```

## Use

```bash
python -m gbt_brain_unify info                  # capability card
python -m gbt_brain_unify spec --json           # machine-readable contract
python -m gbt_brain_unify check --payload '{"goal": "<在此填写>"}'
python -m gbt_brain_unify run   --payload '{"goal": "<在此填写>"}'
```

Real `info` output from this machine:

```text
brain_unify  (llm)  v1.0.0
----------------------------------------
大脑执行层·五维合一：一次跑完 route → execute → verify → health（**是顺序串链，数据顺着走**：route 的 best.kind 喂给 execute，chain 字典逐步累积）。🔴 2026-09-22 更正：这里原先写着「**星形**，unify 直接分别调四维，**不是**串链，那三条边在源码里查不到」—— **那句是错的**，已实测推翻：能力位 `brain_unify` 由 `api.py:313` 直接调 `brain_exec.unify()`，而该函数 **405/419/423/428 行**就是那三条边（route→execute→verify→health），`tests/test_framework.py:1209 test_brain_unify_chain` 也一直在测它。⇒ **别再把「自报是话术」用在这个位上**。唯一真实的那半条限定：`execute()` 只在**没给 kind** 时才会自己再调一次 route（`brain_exec.py:259`），而 unify 一定把 kind 传下去 ⇒ 不会双路由。⚠️ 口径补一句（2026-09-22 第二次独立复核后加，免得再来一轮争论）：**叫它「星形」也不算错** —— 从**调用图**看确实是 unify 这一个中枢分别调四维；错的只有原先那句「**那三条边在源码里查不到**」（它们在 405/419/423/428 行）。**串链说的是执行顺序与数据流，星形说的是调用图，两个层次，别互相否掉。**

gated      : False
external   : False
multi-op   : False
params     : goal
             意图 goal（或 kind 指定能力）
```

Wire a real implementation:

```python
from gbt_brain_unify import run

class MyBackend:
    name = "my-backend"
    def invoke(self, cap, payload):
        return {"cap": cap, "handled": sorted(payload)}

result = run({"goal": "<在此填写>"}, backend=MyBackend())
assert result.status == "ok"
```

## Parameters

| name | required | notes |
|---|---|---|
| `goal` | yes | declared required by the registry |

Registry hint (`params_hint`): 意图 goal（或 kind 指定能力）

Types are deliberately absent: the registry does not declare them, and an invented
type is worse than no type, because callers believe it.

## Boundaries

- Not gated: the registry marks this bit `safe: true`.
- No external service dependency declared.
- Single-action bit.
- No implementation ships here. Bring a backend; the protocol is one method.

## What this is not

Not a wrapper around a hosted API. Not a model. Not a promise that calling it does
anything on its own. It is the typed seam plus the validation, which is the part that
stays correct even when the implementation changes.

## Tests

```bash
python -m pytest
```

```text
22 passed, 1 skipped in 0.12s
```

## Provenance

| field | value |
|---|---|
| capability | `brain_unify` |
| domain | `llm` |
| handler | `brain_unify` |
| safe | `True` (gated = `False`) |
| external | `False` |
| atlas page | [llm/brain_unify](https://github.com/gbtweilai-star/gbt-caps/blob/main/caps/llm/brain_unify.md) |
| full index | [https://github.com/gbtweilai-star/gbt-caps](https://github.com/gbtweilai-star/gbt-caps) |

The parent README says 348 capabilities; an AST pass over the registry enumerates
`341 + 0 unimplemented + 0 disabled = 341`. The extra 7 are historical duplicates.
Numbering here follows 341 and matches the `gbt-caps` index one-to-one.

## License

MIT.
