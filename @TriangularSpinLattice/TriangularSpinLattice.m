%%
%   A SpinLattice with triangular geometry, meaning
%   a given site interacts with its horizontal, vertical
%   top right and bottom left neighbors for a total
%   co0rdination number of 6. The representation
%   of such interactions in a 2D matrix are shown
%   as edges beween vertices in the following diagram:
%
%      -O--O--O--O--O--O--O-
%      /| /| /| /| /| /| /|
%       |/ |/ |/ |/ |/ |/ |/
%      -O--O--O--O--O--O--O-
%      /| /| /| /| /| /| /|
%       |/ |/ |/ |/ |/ |/ |/
%      -O--O--O--O--O--O--O-
%      /| /| /| /| /| /| /|
%       |/ |/ |/ |/ |/ |/ |/
%      -O--O--O--O--O--O--O-
%
%   This class implements functionality to the
%   change in energy from flipping a given spin.
%   It also computes and stores the Boltzmann
%   factors for allowed values of dE upon creation
%   of the lattice to reduce computation time during
%   simulation.
%
classdef TriangularSpinLattice < SpinLattice
    
    % Inherited methods
    methods (Static = false)
        
        % Constructor
        function [lattice] = TriangularSpinLattice(L, H, T, steps)
            lattice = lattice@SpinLattice(L, H, T, steps);
        end
              
        % Computes the change in energy of 
        % flipping spin at (x,y) for a square
        % lattice.
        function [dE] = dE(this, x, y)
            % Compute neighbor energy E_n
            E_n = 0;
            for dx = -1:1
                for dy = -1:1
                    % Check horizontal, vertical, top right
                    % and bottom left neighbors
                    if abs(dx) ~= abs(dy) || dx*dy == 1
                        % Makes use of periodic boundary conditions
                        E_n = E_n + this.spins(...
                            mod(x+dx + this.L, this.L) + 1,...
                            mod(y+dy + this.H, this.H) + 1 ...
                        );
                    end
                end
            end
            % Compute total change in energy dE
            dE = 2 * this.spins(x, y) * E_n;
        end
        
        % Sets w for the allowed values of dE
        function initW(this)
            % Allowed dE values
            dEs = [4 8 12];
            % Associated Boltzmann Factors
            boltzmannFactors = exp(-1/(this.T) * dEs);
            this.w = containers.Map(dEs, boltzmannFactors);
        end
        
    end
    
end