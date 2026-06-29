# Verismith FPGA Synthesis Tool Testing Reproduction

This repository contains the reproduction package for the paper:

> Y. Herklotz and J. Wickerson. **Finding and Understanding Bugs in FPGA Synthesis Tools**. FPGA 2020. DOI: `10.1145/3373087.3375310`.

The reproduced scope is the open-source part of the paper workflow: Verismith, Yosys, Icarus Verilog, SymbiYosys, ABC, and Z3. Commercial EDA tools such as Vivado, XST, and Quartus Prime are not included.

## Repository Layout

```text
.
├── configs/          # Verismith 0.6.0.2 experiment configurations
├── bugs/             # Minimized Verilog bug cases extracted from upstream records
├── scripts/          # Environment checks, tool builds, fuzz runs, and bug replays
├── generated/        # Representative Verismith-generated Verilog samples
├── artifacts/        # Intermediate Verilog artifacts for exact-commit comparisons
└── logs/         # Key experiment logs
```

Large generated directories are intentionally not included: full fuzz output folders, `dist-newstyle/`, old Yosys/Icarus source trees, binary tools, and large build logs. The repository is intended to preserve the reproduction scripts and evidence, not the whole local working directory.

## Environment

The reproduction was performed on Windows + WSL2 Ubuntu.

| Component | Version or path |
| --- | --- |
| OS | Ubuntu 24.04.4 LTS on WSL2 |
| Verismith | `0.6.0.2` |
| GHC / Cabal | GHC `8.6.5`, Cabal `3.8.1.0` |
| Yosys | `0.8`, `0.9`, `3333e002`, `70d0f38`, plus selected exact bug commits |
| Icarus Verilog | `10.3` and current system version `12.0` |
| Equivalence backend | SymbiYosys, ABC / `yosys-abc`, Z3 |

The local scripts use these paths:

```bash
/home/m1roirs/verismith_versions/0.6.0.2/bin/verismith
/home/m1roirs/yosys_versions/0.8/bin/yosys
/home/m1roirs/yosys_versions/0.9/bin/yosys
/home/m1roirs/yosys_versions/3333e002/bin/yosys
/home/m1roirs/yosys_versions/70d0f38/bin/yosys
/home/m1roirs/iverilog_versions/10.3/bin/iverilog
/usr/bin/yosys-abc
```

If the repository is run on another machine, update absolute paths in `configs/*.toml` and `scripts/*.sh`.

## Quick Reproduction

Run from the repository root in WSL Ubuntu.

Collect tool versions:

```bash
bash scripts/collect_open_source_versions_v0602.sh
```

Make old Yosys builds find the system ABC binary:

```bash
bash scripts/link_system_abc_for_old_yosys.sh
```

Replay the paper/artifact seed cases:

```bash
bash scripts/run_paper_seed_cases_v0602_after_abc.sh
```

Replay known Yosys bugs and exact affected/fixed commit comparisons:

```bash
bash scripts/run_known_yosys_direct_bugs.sh
bash scripts/run_yosys_exact_bug_cases.sh
bash scripts/run_yosys_affected_fixed_compare.sh
```

Replay Icarus Verilog Issue 283:

```bash
bash scripts/run_icarus_issue283_current.sh
bash scripts/run_icarus_issue283_10_3.sh
```

Run the small program-size sweep:

```bash
bash scripts/run_size_sweep_sby_20_30_40_v0602.sh
```

## Evidence Summary

Key evidence is stored in `evidence/logs/` and `evidence/screenshots/`.

| Result | Evidence |
| --- | --- |
| Tool and environment versions | `evidence/logs/open_source_tool_versions_v0602.txt`, `evidence/screenshots/01_environment_versions_v0602.png` |
| Old Yosys builds need `yosys-abc` in their install prefix | `evidence/logs/link_system_abc_for_old_yosys.log`, `evidence/screenshots/03_abc_environment_fix_full_original_style.png` |
| Yosys 0.9 small fuzz run, `n=10`, passed after ABC path repair | `evidence/logs/fuzz_yosys_0_9_n10_v0602_abc.log` |
| Yosys 0.8 small fuzz run, `n=3`, exposed failures/timeouts | `evidence/logs/fuzz_yosys_0_8_n3_v0602_abc.log` |
| Yosys Issue 993 crash reproduced at `70d0f38` | `bugs/known_yosys_6_issue993_crash.v`, `evidence/logs/known_yosys_issue993_yosys_70d0f38.log` |
| Yosys Issue 997 / 1047 / 1243 / 1531 exact commit comparisons | `artifacts/yosys_exact_bugs/`, `artifacts/yosys_affected_fixed/`, `evidence/logs/yosys_affected_fixed_compare.log` |
| Icarus Issue 283 differs between 10.3 and current version | `bugs/known_icarus_10_issue283.v`, `evidence/logs/icarus_issue283_10_3_summary.log`, `evidence/logs/icarus_issue283_current_summary.log` |
| Verismith reduction workflow ran on a failing seed | `evidence/logs/fuzz_yosys_70d0f38_reduction_v0602.log` |
| Larger generated programs increase synthesis/equivalence-check cost | `evidence/logs/fuzz_yosys_0_9_size20_n2_sby_v0602.log`, `evidence/logs/fuzz_yosys_0_9_size30_n2_sby_v0602.log`, `evidence/logs/fuzz_yosys_0_9_size40_n2_sby_v0602.log` |

## Relation to the Paper

This repository reproduces the core open-source workflow:

1. Generate deterministic, synthesizable Verilog with Verismith.
2. Synthesize the design with selected Yosys versions/commits.
3. Compare the original RTL with the synthesized netlist through ABC/PDR or SMT-based equivalence checks.
4. Replay and reduce failing cases.
5. Compare affected and fixed versions for representative Yosys and Icarus bugs.

The following parts are not reproduced here:

- Commercial-tool experiments for Vivado, XST, and Quartus Prime.
- Full Table 2 scale with tens of thousands of fuzz tests.
- The Figure 6 XOR `output.combine` experiment.
- The Figure 8 C-Reduce comparison.

The repository is therefore a reproduction of the paper's open-source toolchain and representative historical bugs, not a full rerun of every experiment in the paper.

## Upstream Projects

- Verismith: https://github.com/ymherklotz/verismith
- Yosys: https://github.com/YosysHQ/yosys
- SymbiYosys: https://github.com/YosysHQ/sby
- Icarus Verilog: https://github.com/steveicarus/iverilog
- Z3: https://github.com/Z3Prover/z3

This repository does not vendor upstream Verismith, Yosys, or Icarus source trees. Rebuild those tools from their upstream projects and follow the corresponding licenses.
