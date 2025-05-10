function MODEL = update_geometry(MODEL)

for k = 1 : MODEL.nnodes

    K = 3*k;
    dUx = MODEL.dU(K-2);
    dUy = MODEL.dU(K-1);

    MODEL.xx(k, :) = MODEL.xx(k, :) + [dUx, dUy];
    
end

end