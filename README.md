# Non-Linear-Analysis

A collection of MATLAB finite element codes for geometrically nonlinear structural analysis, developed as part of the **Nonlinear Analysis of Aerospace Structures** course at [Politecnico di Milano](https://www.polimi.it/).

---

## Overview

This repository provides two self-contained FEM modules targeting different structural models:

| Module | Element type | Dimensions | Formulations |
|---|---|---|---|
| `Beams/` | 2-node Timoshenko beam | 2D planar | Geometrically nonlinear |
| `Continuum/` | Quadrilateral / Hexahedral solid | 2D & 3D | Total Lagrangian (TL), Updated Lagrangian (UL) |

Both modules share the same solver architecture and support multiple nonlinear solution strategies selectable at runtime.

---

## Repository Structure

```
Non-Linear-Analysis/
├── Beams/
│   ├── functions/          # Core FEM routines for beam elements
│   ├── examples/           # Ready-to-run example scripts
│   └── input_files/        # Problem definition files
└── Continuum/
    ├── functions/          # Core FEM routines for solid elements
    ├── examples/           # Ready-to-run example scripts
    └── input files/        # Problem definition files
```

---

## Features

### Beam Module

- **2-node planar beam element** with 3 DOFs per node (axial, transverse, rotation).
- **Nonlinear strain measures** via the B-matrix formulation, including both material (`Kc`) and geometric (`Kg`) stiffness contributions.
- **Local-to-global transformation** automatically computed from element orientation angle.
- **Gauss quadrature** integration with configurable number of integration points.
- **Post-processing**: deformed shape plots and equilibrium path tracking.

### Continuum Module

- **2D and 3D solid elements**, supporting both quadrilateral and serendipity 20-node hexahedral topologies.
- **Total Lagrangian (TL)** and **Updated Lagrangian (UL)** formulations, selectable per simulation.
- **Kinematic gradients, constitutive matrix, and Cauchy/PK2 stresses** computed at each Gauss point via dedicated routines.
- **Voigt notation utilities** for consistent stress/strain handling.
- **Stress recovery** from Gauss points to nodes.
- **MEX compilation support** via included MATLAB Coder project files.

### Nonlinear Solvers (both modules)

Five solution strategies are implemented and selectable via `SOL.solver`:

| Solver | Type | Description |
|---|---|---|
| `'Newton'` | Load control | Full Newton-Raphson: tangent stiffness updated every iteration |
| `'Modified_Newton'` | Load control | Modified Newton-Raphson: tangent frozen after the first iteration of each increment |
| `'Riks'` | Arc-length | Riks-Wempner hyperplane constraint: follows the equilibrium path past limit points |
| `'Ramm'` | Arc-length | Ramm variant: uses the current accumulated displacement as arc direction |
| `'Crisfield'` | Arc-length | Crisfield spherical constraint: solves a quadratic equation for the load increment |

All arc-length methods share a common **predictor** step that normalises the arc length and automatically detects the correct sign of the load increment to avoid path reversals.

---

## Getting Started

### Requirements

- MATLAB R2019b or later (no additional toolboxes required for basic usage).
- MATLAB Coder (optional, for MEX compilation of the Continuum solver).

### Running an Example

1. Clone the repository:
   ```bash
   git clone https://github.com/PaneeVino/Non-Linear-Analysis.git
   ```
2. Open MATLAB and add the desired module to the path:
   ```matlab
   addpath(genpath('Beams/'))
   ```
3. Navigate to `Beams/examples/` or `Continuum/examples/` and run one of the provided scripts.

---

## Key Implementation Details

### Stiffness Assembly

The tangent stiffness matrix is split into two contributions assembled via Gauss quadrature:

- **Material stiffness** `Kc`: captures the elastic response.
- **Geometric stiffness** `Kg`: captures the destabilising effect of pre-stress, which is critical for buckling and post-buckling analyses.

### Constraint Application

Boundary conditions are enforced by row/column elimination on the condensed system matrices, keeping the global matrices intact for post-processing.

### Data Structures

The code relies on three main MATLAB structs passed through all functions:

| Struct | Contents |
|---|---|
| `MODEL` | Mesh data, material properties, stiffness matrices, internal forces |
| `SOL` | Solver settings, load parameter lambda, convergence tolerances, iteration counters |
| `POST` | Equilibrium path history for post-processing and plotting |

---

## Academic Context

These codes were developed as part of the coursework for the **Nonlinear Analysis of Aerospace Structures** course at Politecnico di Milano. Benchmark problems include classical test cases from the literature (e.g., Wriggers' *Nonlinear Finite Element Methods*) covering large-displacement bending, snap-through, and post-buckling of beams and continuum bodies.

---

## License

This repository is shared for educational purposes. If you use or adapt this code, please acknowledge the source.
