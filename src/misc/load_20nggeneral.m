if ~exist('ngname1', 'var')
ngname1 = 'alt.atheism';
ngname2 = 'talk.religion.misc';
end

outputname = ['../data/20ng/allSStrNG_' ngname1 '_TOK3nh.mat'];

if ~exist(outputname, 'file')
allSStrNG = {};
path = ['../data/20ng/' ngname1 '/*'];
names = dir(path);
for i = 1:length(names)
    if isempty(strfind(names(i).name, '.tod3'))
        continue;
    end
    fid = fopen(['../data/20ng/' ngname1 '/' names(i).name], 'r');
    if fid == -1
        continue
    end
    content = textscan(fid, '%s', 'bufsize', 100000);
    fclose(fid);

    allSStrNG{end+1} =  content{1};
end
numathe = length(allSStrNG);

path = ['../data/20ng/' ngname2 '/*'];
names = dir(path);
for i = 1:length(names)
    if isempty(strfind(names(i).name, '.tod3'))
        continue;
    end
    fid = fopen(['../data/20ng/' ngname2 '/' names(i).name], 'r');
    if fid == -1
        continue
    end
    content = textscan(fid, '%s', 'bufsize', 100000);
    fclose(fid);

    allSStrNG{end+1} =  content{1};
end


labels = false(1,length(allSStrNG));
labels(1:numathe) = true;
save(outputname, 'allSStrNG', 'labels');

else
    load(outputname);
end

%%
allSStr = allSStrNG;
N = length(allSStr);
themap = containers.Map;

count = 1;
allSNumBi = {};
wordsbi = {};
for i = 1:N
    if mod(i,200) == 0
        fprintf('N %d %d\n', i, count);
    end
    allSNumBi{i} = [];
    for j = 1:length(allSStr{i})
        
        str = lower(allSStr{i}{j});
%         str(~ismember(str,['a':'z'])) = '';
        currentword = str;
        
        try themap(currentword);
        catch
            themap(currentword) = count;
            wordsbi{count} = currentword;
            count = count + 1;
        end
        allSNumBi{i} = [allSNumBi{i} themap(currentword)];
    end
end



save(['../data/20ng/unigram_ng20_' ngname1 '_TOK3nh.mat'], 'allSNumBi', 'wordsbi', 'allSStr', 'labels', 'themap');


for i = 1:N
    if mod(i,200) == 0
        fprintf('N %d %d\n', i, count);
    end
    if isempty(allSStr{i})
         continue;
    end
    for j = 0:length(allSStr{i})
        
        
        if j == 0
            cbigram = strcat('*start*', '-', allSStr{i}{j+1});
        elseif j==length(allSStr{i})
            cbigram = strcat(allSStr{i}{j}, '-', '*end*');
        else
            cbigram = strcat(allSStr{i}{j} ,'-', allSStr{i}{j+1});
        end
        cbigram = lower(cbigram);
%         cbigram(~ismember(cbigram,['a':'z'])) = '';
        
        try themap(cbigram);
        catch
            themap(cbigram) = count;
            wordsbi{count} = cbigram;
            count = count + 1;
        end
        
        allSNumBi{i} = [allSNumBi{i} themap(cbigram)];
    end
    
end


save(['../data/20ng/bigram_ng20_' ngname1 '_TOK3nh.mat'], 'allSNumBi', 'wordsbi', 'allSStr', 'labels', 'themap');
