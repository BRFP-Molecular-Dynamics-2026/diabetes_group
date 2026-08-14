# Running the Example GROMACS Script

Bash scripts can automate a complete GROMACS workflow. A similar approach is used on supercomputers and clusters, where simulation commands are placed inside job scripts. This is only an example—you can also run each command individually.
You can even modify it to make it more robust using your command line tools. Example would be making automatic selection of force fields and other options, also checking for previous runs of simulation to continue it from previous check point, and many more. 

## File Organization

The script is in `scripts/`, while the parameter files are in `parameters/`. Place your PDB file in the repository’s main directory:

```text
repository/
├── protein.pdb
├── scripts/
│   ├── example_script.sh
│   └── instruction.md
└── parameters/
    ├── ions.mdp
    ├── minimi.mdp
    ├── nvt_equili.mdp
    ├── npt_equili.mdp
    └── production.mdp
```
Just keep in mind to run this particular script this is how you want to organize your file structure. Here repository refers to your group's particular github repos.

## Run the Script

Open a terminal in the repository’s main directory and run:

```bash
bash scripts/example_script.sh \
    protein.pdb \
    parameters/ions.mdp \
    parameters/minimi.mdp \
    parameters/nvt_equili.mdp \
    parameters/npt_equili.mdp \
    parameters/production.mdp
```

Replace `protein.pdb` with your actual PDB filename.

GROMACS will ask you to select the force field, the `SOL` group, `Potential`, and `Temperature`.

## Using a GPU

Check for an NVIDIA GPU:

```bash
nvidia-smi
```

If a compatible GPU and GPU-enabled GROMACS are available, add `-nb gpu` to every `gmx mdrun` command:

```bash
gmx mdrun -deffnm production -cpt 5 -v -nb gpu
```

Without a GPU, leave the commands unchanged.

All generated simulation files will appear in the repository’s main directory.
