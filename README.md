# TemperatureCabin

A MATLAB simulation of the 3D transient temperature distribution inside a vehicle cabin, modeled with a finite-difference heat-transfer scheme and visualized as a color-mapped point cloud.

## Overview

This project models heat exchange between the cabin air, cabin surfaces (roof, windows, floor), an occupant, and the vents of an air-conditioning/heating system. The cabin interior is discretized into a 3D grid, and temperature at each grid point is updated iteratively based on conduction between neighboring cells, using per-material transfer coefficients (air-to-air, air-to-wall, window-to-air, skin-to-air, and vent-to-air).

The result is a time-evolving 3D temperature field that can be visualized to study how quickly a cabin cools or heats, and how evenly temperature is distributed around the occupant.

## Model

- **Grid**: a 25 × 17 × 15 (X × Y × Z, in decimeters) volume representing the cabin's lower (seating) and upper (headroom) compartments, solved as two coupled regions.
- **Boundary conditions**: fixed temperatures are imposed on the roof, floor, side walls, and glass surfaces to represent ambient/exterior conditions.
- **Heat sources**:
  - An occupant, modeled as a fixed-temperature block (37 °C) at a configurable location.
  - Vents, modeled as fixed-temperature regions (`T_ac`) representing AC/heater output.
- **Conduction coefficients** (`k1`–`k5`): tunable constants controlling how quickly heat diffuses between air, walls, windows, vents, and the occupant's skin.
- **Time-stepping**: at each iteration the temperature of every interior grid cell is updated from the temperatures and conduction coefficients of its six neighbors, then boundary conditions are reapplied.

## Files

| File | Description |
|---|---|
| [`fourac.m`](fourac.m) | Simulation with a 4-vent AC/heater layout. |
| [`threeac.m`](threeac.m) | Simulation with a 3-vent AC/heater layout, for comparison against the 4-vent case. |
| [`1-3cooling.fig`](1-3cooling.fig) | MATLAB figure comparing 1-vent vs. 3-vent cooling performance. |
| [`1-3heating.fig`](1-3heating.fig) | MATLAB figure comparing 1-vent vs. 3-vent heating performance. |
| [`cooling10s.fig`](cooling10s.fig) | Cabin temperature distribution after 10 seconds of cooling. |
| [`cooling100s.fig`](cooling100s.fig) | Cabin temperature distribution after 100 seconds of cooling. |
| [`cooling600s.fig`](cooling600s.fig) | Cabin temperature distribution after 600 seconds of cooling. |

## Getting Started

**Requirements**: MATLAB (no additional toolboxes required).

**Run a simulation**:
```matlab
fourac    % or: threeac
```

Each script initializes the cabin's temperature field, runs the finite-difference update loop, and renders a 3D scatter plot of the resulting temperature distribution with a colorbar (°C).

**View saved results**:
```matlab
openfig('cooling100s.fig')
```

## Configuration

Key parameters can be adjusted at the top of `fourac.m` / `threeac.m`:

- `T0` — ambient temperature
- `T_top` — roof/exterior temperature
- `T_ac` — vent output temperature
- `a`, `b` — occupant position on the X/Y axes
- `k1`–`k5` — conduction coefficients for air, walls, windows, vents, and skin

## License

Released under the [MIT License](LICENSE).
