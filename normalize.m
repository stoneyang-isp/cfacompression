function out = normalize(in, a, b)

out = (b-a) / (max(in(:))-min(in(:))) * (in - min(in(:))) + a;

return