# This is just a example shell script. 
# Given parameters and gmx installed in your machine, it will automatically run till simulation.

# This will take input from you for parameters files and protien files to be simulated
echo "You are running this script : $0"
echo "This will be your pdb file name : $1"
echo "This will be your mdp file for ions : $2"
echo "This will be your mdp file for energy minimization : $3"
echo "This will be your mdp file for NVT equilibiration : $4"
echo "This will be your mdp file for NPT equilibiration : $5"
echo "This will be your mdp file for final simulation run : $6"

echo -e "\n\tNow lets check for gmx installation"
gmx --version

# After successfully verifying now lets load our pdb file and get rid of crystalline HOH molecules
grep -v HOH $1 > clean_$1

echo "New clean pdb file generated is : clean_$1"

echo "Now we are assigning the force field to our pdb file"

gmx pdb2gmx -f clean_$1 -o clean_processed.gro -water spce -ignh

gmx editconf -f clean_processed.gro -o clean_box.gro -c -d 1.0 -bt cubic

gmx solvate -cp clean_box.gro -cs spc216.gro -o clean_solv.gro -p topol.top

gmx grompp -f $2 -c clean_solv.gro -p topol.top -o ions.tpr -maxwarn 3

gmx genion -s ions.tpr -o clean_solv_ions.gro -p topol.top -pname NA -nname CL -neutral -conc 0.15

gmx grompp -f $3 -c clean_solv_ions.gro -p topol.top -o em.tpr

# if you have gpu use gmx mdrun -v -deffnm em -nb gpu
gmx mdrun -v -deffnm em

echo "Hey so we can to see potential energy over the minimization steps so choose group number with potential"
echo "It will generate xvg file which you can plot "
gmx energy -f em.edr -o potential.xvg

gmx grompp -f $4 -c em.gro -r em.gro -p topol.top -o nvt.tpr

#  here to if you have gpu use gmx mdrun -deffnm nvt -nb gpu
gmx mdrun -deffnm nvt

gmx energy -f nvt.edr -o temperature.xvg

gmx grompp -f $5 -c nvt.gro -r nvt.gro -p topol.top -o npt.tpr

gmx mdrun -deffnm npt

gmx grompp -f $6 -c npt.gro -p topol.top -o production.tpr

gmx mdrun -deffnm production -cpt 5 -v
