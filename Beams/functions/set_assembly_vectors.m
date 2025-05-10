function MODEL = set_assembly_vectors(MODEL)

MODEL.ptrs = nan(MODEL.nels, 6);

for i = 1 : MODEL.nels
    el = MODEL.elements(i, :);

    for k = 1 : length(el)
        node = el(k);
        K = 3*k;
        MODEL.ptrs(i, [K-2,K-1,K]) = MODEL.pos(node, :);
    end

end

end