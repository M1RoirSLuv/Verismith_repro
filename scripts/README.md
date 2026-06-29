# Script Index

Run scripts from the repository root. All scripts source `scripts/common.sh`, so the repository root is detected automatically. If needed, override it with:

```bash
REPRO_ROOT=/path/to/verismith-reproduction bash scripts/experiments/run_yosys_exact_bug_cases.sh
```

Most scripts still assume the local tool installation paths recorded in the paper reproduction:

```text
/home/m1roirs/verismith_versions/0.6.0.2
/home/m1roirs/yosys_versions/<version-or-commit>
/home/m1roirs/iverilog_versions/10.3
```

Adjust those paths before running on another machine.

## Recommended Reproduction Order

1. Check versions:

```bash
bash scripts/env/collect_open_source_versions_v0602.sh
```

2. Repair old Yosys ABC paths:

```bash
bash scripts/env/link_system_abc_for_old_yosys.sh
```

3. Replay paper/artifact seeds:

```bash
bash scripts/experiments/run_paper_seed_cases_v0602_after_abc.sh
```

4. Replay known Yosys bugs:

```bash
bash scripts/experiments/run_known_yosys_direct_bugs.sh
bash scripts/experiments/run_yosys_exact_bug_cases.sh
bash scripts/experiments/run_yosys_affected_fixed_compare.sh
```

5. Replay Icarus Issue 283:

```bash
bash scripts/experiments/run_icarus_issue283_current.sh
bash scripts/experiments/run_icarus_issue283_10_3.sh
```

6. Run the small program-size sweep:

```bash
bash scripts/experiments/run_size_sweep_sby_20_30_40_v0602.sh
```

## Directory Roles

- `env/`: environment/version checks and small dependency fixes.
- `build/`: helper scripts for building old Yosys and Icarus versions.
- `experiments/`: main reproduction experiments used by the report.
- `analysis/`: optional reduction or follow-up analysis.
