close all
clear all
load matlabData.mat %loads data - books, ratings, users

%% Data filtering
title = "Lord of the Rings"; % Books with LOTR in the title - eliminates versions in other languages
author = "R. Tolkien"; % Only books written by J.R.R. Tolkien
avoidTitle = ["El Senor","French","History","Cover","Guide","Hobbit","Dramatization"]; % keywords to avoid
lotrBooks = books(contains(books.Book_Title,title,'IgnoreCase',true) & ... 
                  contains(books.Book_Author,author,'IgnoreCase',true) & ...
                  not(contains(books.Book_Title,avoidTitle,'IgnoreCase',true)),:);
              




