function MODEL = update_displacements(MODEL)

for k = 1 : MODEL.nnodes

Pos = MODEL.pos(k, :);
MODEL.dU_nodes(k, :) = MODEL.dU(Pos).';

end

MODEL.U_nodes = MODEL.U_nodes + MODEL.dU_nodes;

for k = 1 : MODEL.nels

    Nodes = MODEL.elements(k, :);

    MODEL.Ux(k, :) = MODEL.Ux(k, :) + MODEL.dU_nodes(Nodes, 1).';
    MODEL.Uy(k, :) = MODEL.Uy(k, :) + MODEL.dU_nodes(Nodes, 2).';

    if MODEL.dim == 3
        MODEL.Uz(k, :) = MODEL.Uz(k, :) + MODEL.dU_nodes(Nodes, 3).';
    end

end

end