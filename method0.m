%% Method 0
% just recommend the best books
% for reference

close all
clear all

%% Load data
load matlabData.mat %loads data - books, ratings, users
     
[recommended.ISBN,ia,ic] = unique(ratings.ISBN); % unique ISBNs of ratings
recommended.Reads = accumarray(ic,1); % number of reviews of individual books
recommended.Rating = accumarray(ic,str2double(ratings.Book_Rating),[],@mean); %average rating
recommended = struct2table(recommended); % Put the data in a table

recommended.Score = bookScore(recommended.Rating,recommended.Reads);
recommended = sortrows(recommended,'Score','descend'); %Sort recommended according to score

%% Display books
numberOfDisplayedBooks = 3; % Top 3 - fits into a window
numberOfDisplayedBooksConsole = 10; % Larger set to be written as a console output
finalISBNs = recommended.ISBN(1:numberOfDisplayedBooksConsole); %Read ISBNs of best rated books
booksToDisplay = table();

for i = 1:numberOfDisplayedBooksConsole
   booksToDisplay = [booksToDisplay;books(ismember(books.ISBN,finalISBNs(i)),:)]; %Read data for the best rated books
end
booksToDisplay.Score = recommended.Score(1:numberOfDisplayedBooksConsole); %Add score value to the table

for i =1:numberOfDisplayedBooksConsole
    disp([i,booksToDisplay.Book_Title(i),booksToDisplay.Score(i)]); % Console output
end
    
fh = figure(); %Display best rated books in a window
fh.WindowState = 'maximized';
for i = 1:numberOfDisplayedBooks
    subplot(1,numberOfDisplayedBooks,i)
    [url_img, map] = imread(string(booksToDisplay.Image_URL_L(i)));
    imshow(url_img)
    title(strcat(num2str(i),'. ',string(booksToDisplay.Book_Title(i))))
    xlabel(strcat('Score: ', num2str(booksToDisplay.Score(i))))
end

%% Diagnostics
figure()
histogram(str2double(ratings.Book_Rating))
title('Histogram of all ratings')
xlabel('Rating')
ylabel('Number of ratings')



