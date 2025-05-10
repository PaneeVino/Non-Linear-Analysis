function MODEL = set_assembly_vectors(MODEL)
% SET_ASSEMBLY_VECTORS computes assembly vectors for the finite element model.
%
% This function populates the `MODEL.ptrs` matrix, which contains the global
% degrees of freedom (DOFs) corresponding to each element's local DOFs. These
% vectors are used during the assembly process to map local element contributions
% (e.g., stiffness matrices, force vectors) into the global system.
%
% Inputs:
%   MODEL - Structure containing the finite element model information:
%       - MODEL.elements: Element connectivity matrix [n_elements x n_nodes_per_element]
%       - MODEL.nodes: Nodal coordinates [n_nodes x n_dimensions]
%       - MODEL.pos: Global DOF indices for each node [n_nodes x n_dimensions]
%       - MODEL.nels: Number of elements
%
% Outputs:
%   MODEL - Updated structure with an additional field:
%       - MODEL.ptrs: Assembly vectors [n_elements x (n_nodes_per_element * n_dimensions)]
%         Each row contains the global DOFs associated with an element's local DOFs.

% Initialize the assembly vector matrix with NaN values
dim = MODEL.dim;
MODEL.ptrs = nan(MODEL.nels, MODEL.eltype * dim);

% Loop over each element
for i = 1 : MODEL.nels
    el = MODEL.elements(i, :); % Nodes of the current element
    for k = 1 : length(el)     % Loop over nodes of the element
        node = el(k); % Get the node index
        % Assign the global DOFs corresponding to this node
        switch dim
            case 2
                MODEL.ptrs(i, [dim*k-1, dim*k]) = MODEL.pos(node, :);
            case 3
                MODEL.ptrs(i, [dim*k-2,dim*k-1, dim*k]) = MODEL.pos(node, :);
        end
    end
end

return
