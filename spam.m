clear; clc;
vocabList = getVocabList();
indices = [];

load('spamTrain.mat');
fprintf('\nTraining Linear SVM (Spam Classification)\n');

C = 0.1;
model = svmTrain(X, y, C, @linearKernel);

p = svmPredict(model, X);

fprintf('Training Accuracy: %f\n', mean(double(p == y)) * 100);

fid = fopen('spam2.txt');
if fid
    file_contents = fscanf(fid, '%c', inf);
    fclose(fid);
else
    file_contents = '';
    fprintf('Unable to open %s\n', filename);
end

email_contents = lower(file_contents);

email_contents=regexprep(email_contents,'<[^<>]+>',' ');
email_contents=regexprep(email_contents,'\d+','number');
email_contents=regexprep(email_contents,'(http|https)://[^/s]+','httpaddr');
email_contents=regexprep(email_contents,'[^\s]+@[a-zA-Z]\.[a-zA-Z]','emailaddr');
email_contents=regexprep(email_contents,'<[^<>]+>',' ');
email_contents = regexprep(email_contents, '[$]+', 'dollar');


while ~isempty(email_contents)

	[str email_contents] =strtok(email_contents,[' @$/#.%-:&*+=[]?!(){},''">_<;']);
	str = regexprep(str, '[^a-zA-Z0-9]', '');
	    try str = porterStemmer(strtrim(str)); 
			catch str = ''; 
			continue;
		end;
	 if length(str) < 1
       continue;
    end


	for idx = 1 : length(vocabList)
		if strcmp(str,vocabList(idx)) == 1
        indices = [indices ; idx ] ; 
		end
	end
	
	fprintf('%s ',str);

end

n = 1899;

x = zeros(n, 1);

for i = 1:length(indices)
    x(indices(i))  = 1;
end

p = svmPredict(model, x);
fprintf('\n%d \n',p);
fprintf('\n(1 indicates spam, 0 indicates not spam)\n\n');
