[![INFORMS Journal on Computing Logo](https://INFORMSJoC.github.io/logos/INFORMS_Journal_on_Computing_Header.jpg)](https://pubsonline.informs.org/journal/ijoc)

This archive is distributed in association with the [INFORMS Journal on
Computing](https://pubsonline.informs.org/journal/ijoc) under the
[MIT license](LICENSE.md).

The software, StochasticPrograms.jl, and data in this repository are associated with the paper
[Efficient Stochastic Programming in Julia]()
by M. Biel and M. Johansson.

StochasticPrograms.jl is a general purpose modeling framework for stochastic programming written in the Julia programming language. The framework includes both modeling tools and structure-exploiting optimization algorithms. Stochastic programming models can be efficiently formulated using expressive syntax and models can be instantiated, inspected, and analyzed interactively. The framework scales seamlessly to distributed environments. Small instances of a model can be run locally to ensure correctness, while larger instances are automatically distributed in a memory-efficient way onto supercomputers or clouds and solved using parallel optimization algorithms. These structure-exploiting solvers are based on variations of the classical L-shaped and progressive-hedging algorithms.

This repository is a snapshot of the project, taken on 2021-07-01 from
[https://github.com/martinbiel/StochasticPrograms.jl](https://github.com/martinbiel/StochasticPrograms.jl) at commit
[`302400e4de2708d5fba50fedeb134c33f128b808`](https://github.com/martinbiel/StochasticPrograms.jl/commit/302400e4de2708d5fba50fedeb134c33f128b808),
and is provided for historical interest.

To cite this software, please cite the [paper]() using its DOI
and the software itself, using the following DOI.

<!-- [![DOI](https://zenodo.org/badge/290669197.svg)](https://zenodo.org/badge/latestdoi/290669197) -->

Readers are directed to [https://github.com/martinbiel/StochasticPrograms.jl](https://github.com/martinbiel/StochasticPrograms.jl)
for the actively developed project repository, and to
[https://martinbiel.github.io/StochasticPrograms.jl/latest/](https://martinbiel.github.io/StochasticPrograms.jl/latest/)
for the latest documentation. In Julia, the latest version of the framework can be installed through `pkg> add StochasticPrograms`.

The code listings included in the paper are provided as separate Julia files in the `scripts` folder. To run the example in the paper, first install any 1.X version of Julia (e.g., 1.0 or 1.6) from [julialang.org](https://julialang.org/downloads). The provided `install.sh` script can be used to download the latest version of Julia (1.6.0) and then load `install.jl` which installs the StochasticPrograms.jl package as well as any other Julia packages necessary to run the examples. The benchmark code as well as data files for the large-scale SSN problem considered in the numerical experiments are included as well in the `scripts` folder. The experiments were run on a 32-core machine. To run the experiments in another setup, the `benchmark.jl` must be configured accordingly. A license is required to use Gurobi as a subproblem solver. Free third-party solvers can be used instead, but performance will be affected.
