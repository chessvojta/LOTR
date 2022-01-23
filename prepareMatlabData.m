close all
clear all

books = readtable('data/BX-CSV-Dump/BX-Books.csv');
ratings = readtable('data/BX-CSV-Dump/BX-Book-Ratings.csv');
users = readtable('data/BX-CSV-Dump/BX-Users.csv');

save('matlabData')