function vocab = getVocabList()

n = 1899;
vocab = cell(n,1);

text =fopen('vocab.txt');

for i=1:n
	t=fscanf(text,'%d',1);
	str = fscanf(text,'%s',1);
	vocab{i}=str;
end

fclose(text);

end