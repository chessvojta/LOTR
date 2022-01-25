close all
clear all

%% Load data
load matlabData.mat %loads data - books, ratings, users

%% Filter books
bookTtitle = "Lord of the Rings"; % Books with LOTR in the title - eliminates versions in other languages
author = "R. Tolkien"; % Only books written by J.R.R. Tolkien
avoidTitle = ["El Senor","French","History","Cover","Guide","Hobbit","Dramatization"]; % keywords to avoid
lotrBooks = books(contains(books.Book_Title,bookTtitle,'IgnoreCase',true) & ... 
                  contains(books.Book_Author,author,'IgnoreCase',true) & ...
                  not(contains(books.Book_Title,avoidTitle,'IgnoreCase',true)),:);

%% Filter ratings              
lotrRatings = ratings(ismember(ratings.ISBN,lotrBooks.ISBN),:); % all ratings of defined LOTR books

thresholdPositive = 7;
positiveLotrRatings = lotrRatings(str2double(lotrRatings.Book_Rating)>=thresholdPositive,:);

%thresholdNegative = 1;
%negativeLotrRatings = lotrRatings(str2double(lotrRatings.Book_Rating)<=thresholdNegative,:);

%% Filter users and their ratings
posUsers = users(ismember(users.User_ID,positiveLotrRatings.User_ID),:); %users that liked LOTR
posUsersPosRatings = ratings(ismember(ratings.User_ID,positiveLotrRatings.User_ID) &...
                               str2double(ratings.Book_Rating)>=thresholdPositive,:);
% positive reviews of users that liked LOTR                           

%% Recommend books based on users that liked LOTR
[recommended.ISBN,ia,ic] = unique(posUsersPosRatings.ISBN); % unique ISBNs of books liked by LOTR likers
recommended.Reads = accumarray(ic,1); % number of reviews of individual books by LOTR likers
recommended.Rating = accumarray(ic,str2double(posUsersPosRatings.Book_Rating),[],@mean); %average rating
recommended = struct2table(recommended); % Put the data in a table
recommended = recommended(not(ismember(recommended.ISBN,lotrBooks.ISBN)),:); %Filter out LOTR books

recommended.Score = bookScore(recommended.Rating,recommended.Reads,2); %Score based on rating and reads
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
% figure()
% histogram(str2double(lotrRatings.Book_Rating))
% title('Histogram of LOTR books ratings')
% xlabel('Rating')
% ylabel('Number of ratings')



