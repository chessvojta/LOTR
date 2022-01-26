%% Method 2
% People who liked LOTR also liked... and it is not popular in general
%
% Adapting scoring so that the most popular books are avoided.

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

recommended.LotrScore = bookScore(recommended.Rating,recommended.Reads); %Score based on rating and reads
recommended = recommended(recommended.Reads>1,:); %Filter to reduce computation time
recommended = sortrows(recommended,'LotrScore','descend');
recommended.Score = NaN(length(recommended.LotrScore));

%% Adapt scoring
[general.ISBN,ia,ic] = unique(ratings.ISBN); % unique ISBNs of ratings
general.Reads = accumarray(ic,1); % number of reviews of individual books
general.Rating = accumarray(ic,str2double(ratings.Book_Rating),[],@mean); %average rating
general = struct2table(general); % Put the data in a table
general.Score = bookScore(general.Rating,general.Reads);

for i = 1:length(recommended.ISBN)
    recommended.GeneralScore(i) = general(ismember(general.ISBN,recommended.ISBN(i)),:).Score;
end

recommended.Score = recommended.LotrScore + 10 -recommended.GeneralScore; % 1-norm of a vector starting in [0 10]
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

figure()
plot(recommended.LotrScore,recommended.GeneralScore,'b.')
hold on
plot(recommended.LotrScore(1:numberOfDisplayedBooksConsole),recommended.GeneralScore(1:numberOfDisplayedBooksConsole),'r+')
axis equal
grid on
xlim([0 10])
ylim([0 10])
xlabel('Score by LOTR likers')
ylabel('Score by general readers')

