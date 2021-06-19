% Memory1 = ancienne version en prenant le dernier élément
% TabConfig = [TabConfig , Memory1];

a = find(Memory ~= Memory1);
b = find(Memory == Memory1);
MemoryIssue = TabConfig(a,:);
MemorySame = TabConfig(b,:);
