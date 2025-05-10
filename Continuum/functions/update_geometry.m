function MODEL = update_geometry(MODEL)

MODEL.xx = MODEL.xx + MODEL.dU_nodes;

for k = 1 : MODEL.nels

    Nodes = MODEL.elements(k, :);

    MODEL.x(k, :) = MODEL.xx(Nodes, 1).';
    MODEL.y(k, :) = MODEL.xx(Nodes, 2).';
    
    if MODEL.dim==3
        MODEL.z(k, :) = MODEL.xx(Nodes, 3).';
    end

end

return