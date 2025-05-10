function POST = POST_update_deformed_shape( POST, MODEL, SOL )

nincr = SOL.nincr;
POST.STEP(nincr).X  = MODEL.X;
POST.STEP(nincr).Y  = MODEL.Y;

for k = 1 : MODEL.nels

    Nodes = MODEL.elements(k, :);
    POST.STEP(nincr).x(k, :) = MODEL.xx(Nodes, 1).';
    POST.STEP(nincr).y(k, :) = MODEL.xx(Nodes, 2).';
    
end

end