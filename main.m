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
posUsers = users(ismember(users.User_ID,positiveLotrRatings.User_ID),:);
posUsersPosRatings = ratings(ismember(ratings.User_ID,positiveLotrRatings.User_ID) &...
                               str2double(ratings.Book_Rating)>=thresholdPositive,:);
% positive reviews of users that liked LOTR                           

%% Recommended books based on users that liked LOTR
[recommended.ISBN,ia,ic] = unique(posUsersPosRatings.ISBN); % unique ISBNs of books liked by LOTR likers
recommended.Reads = accumarray(ic,1); % number of reviews of individual books by LOTR likers
recommended.Rating = accumarray(ic,str2double(posUsersPosRatings.Book_Rating),[],@mean); %average rating
recommended.Score = recommended.Rating.*log10(recommended.Reads);

recommended = struct2table(recommended); % Put the data in a table
recommended = recommended(not(ismember(recommended.ISBN,lotrBooks.ISBN)),:); %Filter out LOTR books
recommended = sortrows(recommended,'Score','descend'); %Sort recommended according to score

%% Output
figure()
histogram(str2double(lotrRatings.Book_Rating))
title('Histogram of LOTR books ratings')
xlabel('Rating')
ylabel('Number of ratings')


