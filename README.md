# LOTR
Problem: Book recommendations - „I like Lord of the Rings, what else should I read?“

## First thoughts
- Not much information on the person who asks the question
  - No age, sex, location, other books.
  - Recommendation based only on liking LOTR.
- Tools: MATLAB - in which I am comfortable
  - No googling, no special toolboxes, only MATLAB documentation

## Data check
- There are strange ISBNs in the "ratings" table, such as 'Ô˝crosoft' or 'WEAREWITNESSE'.
  - Ignored for now as these ISBNs are all different and their number is negligible.
- Not all ISBNs in "ratings" are listed in "books".
  - This will be fixed only where needed.
- Users tend to give either a bad rating of 0 or a good rating of 5 - 10. There are far less ratings in the 1-4 range.

![Histogram of all reviews](/images/all_ratings_histogram.png)

## Scoring system
- In order to compare individual books, it is needed to evaluate both their average rating and their popularity.
  - Using only average rating would lead to recommending books rated by 1 person who gave them rating 10.
- The book score is evaluated using function [bookScore.m](bookScore.m)
  - There are multiple methods - the default one is normalized so that the maximum value is equal to 10.
  - The scoring function can surely be improved.

## Method 0 (for reference)
The "zero" method of recommending the book is as simple as possible: just recommend the books with the best score without using the information that the person liked LOTR.
The MATLAB script is [method0.m](method0.m).

This method recommends books:
1. Harry Potter and the Goblet of Fire (Book 4)
2. Harry Potter and the Prisoner of Azkaban (Book 3)
3. Harry Potter and the Chamber of Secrets (Book 2)
4. Harry Potter and the Sorcerer''s Stone (Book 1)
5. Harry Potter and the Order of the Phoenix (Book 5)
6. The Lovely Bones: A Novel
7. Free
8. The Da Vinci Code
9. Harry Potter and the Sorcerer''s Stone (Harry Potter (Paperback))
10. To Kill a Mockingbird

Result: As it seems, the best rated books with this scoring method are Harry Potter books.

Pros: Simple method

Cons: No use of the information that the person liked LOTR

## Method 1 
The first method is based on the principle "people who liked LOTR also liked...". The idea is to select the ratings of people, 
that gave positive ratings to LOTR books and recommend the books that these people liked (according to score).
One problem that arises is how to select books, that are LOTR books. There are books that have LOTR in the name, but are not part of the trilogy (guides, movie covers...),
there are language variation of the books (Die zwei Türme). 

The final decision was to include only English books written by J.R.R. Tolkien, that do not contain several keywords (such as "hobbit"). 
The choice of these keywords was done by hand, it might be difficult to automize. 

The MATLAB script is [method1.m](method1.m).

This method recommends books:
1. The Hobbit : The Enchanting Prelude to The Lord of the Rings
2. Harry Potter and the Order of the Phoenix (Book 5)
3. Harry Potter and the Sorcerer''s Stone (Harry Potter (Paperback))
4. Harry Potter and the Prisoner of Azkaban (Book 3)
5. Harry Potter and the Goblet of Fire (Book 4)
6. Harry Potter and the Chamber of Secrets (Book 2)
7. The Da Vinci Code
8. Harry Potter and the Sorcerer''s Stone (Book 1)
9. Harry Potter and the Chamber of Secrets (Book 2)
10. The Hobbit: or There and Back Again

Result: In this case, the most recommended book is The Hobbit. As long as a person read only LOTR books, The Hobbit seems as a logical choice.
The last contains many Harry Potter books as in method 0, which is maybe not so desirable - as these books are liked by general audience.

Pros: Relativly simple and fast.

Cons: Depends on the proper choice of keywords - to avoid the Hobbit as a LOTR book, recommends generally popular books.

## Method 2 
The sceond method tries to solve the problem of books liked by general audience in method 1. It calculated independently the book score from all readers and the LOTR readers subset. The overall score is then calculated from these 2 - the idea is to choose box that are closest to maximum score by LOTR readers and minimum score by general audience.

![Score of method 2](/images/method2_score.png)

The MATLAB script is [method2.m](method2.m).

This method recommends books:
1. The Hobbit : The Enchanting Prelude to The Lord of the Rings
2. Anne of Windy Poplars (Anne of Green Gables Novels (Paperback))
3. The Hobbit: or There and Back Again
4. Hawaii
5. A Time to Kill
6. Anne of Ingleside (Anne of Green Gables Novels (Paperback))
7. The Secret Garden
8. Harry Potter and the Order of the Phoenix (Book 5)
9. Charlotte''s Web (Trophy Newbery)
10. Foundation and Empire (Foundation Novels (Paperback))

Result: The Hobbit is still at the top of the list, there is only one Harry Potter book left. The choice of Anne of Green Gables Novels seems interesting - it is a well-rated book that does not seem to have much in common with LOTR.

Pros: Recommended books are more specific to people who liked LOTR (in theory).

Cons: Heavily depends on the definition of book score, it is more complicated and slow (this might be solved with better implementation).

## Method 3
The last method exploits the idea of "finding the most simmilar book to LOTR" (in terms of user ratings). In this case, the score is calculate both from positive ratings of users that liked LOTR and negative reviews of users that disliked LOTR. In principle, this recommendation should be more robust than method 1, since it uses more data.

![Score of method 3](/images/method3_score.png)

The MATLAB script is [method3.m](method3.m).

This method recommends books:
1. The Hobbit : The Enchanting Prelude to The Lord of the Rings
2. Harry Potter and the Sorcerer''s Stone (Harry Potter (Paperback))
3. The Da Vinci Code
4. Harry Potter and the Order of the Phoenix (Book 5)
5. Harry Potter and the Chamber of Secrets (Book 2)
6. A Time to Kill
7. To Kill a Mockingbird
8. Memoirs of a Geisha (ISBN not in books list)
9. Interview with the Vampire
10. The Lovely Bones: A Novel

Result: The Hobbit is still at the top of the list, and Harry Potter is (unfortunately) back. 

Pros: Choice of books should be more robust (in theory). Code is relativly fast.

Cons: The recommended books are (as in method 1) popular among general public. There seems to be little connection between these books and LOTR.

# Conclusions
- Among the tested methods, the method 2 seems to give the best results - the books are well-rated and not so much popular among general audience
- Yet it seems that there should be more "connection" between the books
  - The recommendation would be better if books had some "tags", such as "fantasy", "adventure"... 
  - Some algorithm could evaluate simmilarity between books (neural network)?
- If I had more data on the user - age, sex, location, other books they like - I could try to build a regression model - expected rating based on user and book
