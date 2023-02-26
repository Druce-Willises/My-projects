#!/usr/bin/env python
# coding: utf-8

# # Шифр Цезаря

# <h1>Содержание<span class="tocSkip"></span></h1>
# <div class="toc"><ul class="toc-item"><li><span><a href="#Шифрование-текста-на-русском-языке" data-toc-modified-id="Шифрование-текста-на-русском-языке-1"><span class="toc-item-num">1&nbsp;&nbsp;</span>Шифрование текста на русском языке</a></span></li><li><span><a href="#Шифрование-текста-на-английском-языке" data-toc-modified-id="Шифрование-текста-на-английском-языке-2"><span class="toc-item-num">2&nbsp;&nbsp;</span>Шифрование текста на английском языке</a></span></li><li><span><a href="#Дешифрование-текста-на-русском-языке" data-toc-modified-id="Дешифрование-текста-на-русском-языке-3"><span class="toc-item-num">3&nbsp;&nbsp;</span>Дешифрование текста на русском языке</a></span></li><li><span><a href="#Дешифрование-текста-на-английском-языке" data-toc-modified-id="Дешифрование-текста-на-английском-языке-4"><span class="toc-item-num">4&nbsp;&nbsp;</span>Дешифрование текста на английском языке</a></span></li><li><span><a href="#Дешифрование-текста-на-английском-языке-с-неизвестным-ключом" data-toc-modified-id="Дешифрование-текста-на-английском-языке-с-неизвестным-ключом-5"><span class="toc-item-num">5&nbsp;&nbsp;</span>Дешифрование текста на английском языке с неизвестным ключом</a></span></li><li><span><a href="#Шифрование-модифицированным-шифром-цезаря" data-toc-modified-id="Шифрование-модифицированным-шифром-цезаря-6"><span class="toc-item-num">6&nbsp;&nbsp;</span>Шифрование модифицированным шифром цезаря</a></span></li></ul></div>

# ## Шифрование текста на русском языке

# In[67]:


# Шифр рус
rot = 10
string = "Строка" 
list1 = [string[i] for i in range(len(string))]

list2 = []         
for i in range (len(list1)):
    if (ord(list1[i]) >= 1072 and
        ord(list1[i]) <= 1103):
        new_werb = chr(((ord(list1[i]) + rot - 1072) % 32) + 1072)
        list2.append(new_werb)
        
    elif (ord(list1[i]) >= 1040 and
        ord(list1[i]) <= 1071):
        new_werb = chr(((ord(list1[i]) + rot - 1040) % 32) + 1040)        
        list2.append(new_werb)
    else:
        new_werb = list1[i]
        list2.append(new_werb)
        
result = ''.join(list2)
print(result)    


# ## Шифрование текста на английском языке

# In[5]:


# Шифр англ
rot = 17
string = "To be, or not to be, that is the question!" 
list1 = [string[i] for i in range(len(string))]

list2 = []         
for i in range (len(list1)):
    if (ord(list1[i]) >= 65 and
        ord(list1[i]) <= 90):
        new_werb = chr(((ord(list1[i]) + rot - 65) % 26) + 65)
        list2.append(new_werb)
        
    elif (ord(list1[i]) >= 97 and
        ord(list1[i]) <= 122):
        new_werиb = chr(((ord(list1[i]) + rot - 97) % 26) + 97)        
        list2.append(new_werb)
    else:
        new_werb = list1[i]
        list2.append(new_werb)
        
result = ''.join(list2)
print(result)    


# ## Дешифрование текста на русском языке

# In[15]:


# деШифр рус

derot = 7
string = "Шсъцхр щмчжмщ йшм, нмтзж йшм лхшщзщг." 
list1 = [string[i] for i in range(len(string))]

list2 = []         
for i in range (len(list1)):
    if (ord(list1[i]) >= 1072 and
        ord(list1[i]) <= 1103):## Шифрование текста на английском языке
        if ord(list1[i]) - 1072 - derot < 0:
            new_werb = chr(32 + (ord(list1[i]) - derot))
        else:
            new_werb = chr(((ord(list1[i]) - derot - 1072) % 32) + 1072)
        list2.append(new_werb)
        
    elif (ord(list1[i]) >= 1040 and
        ord(list1[i]) <= 1071):
        if ord(list1[i]) - 1040 - derot < 0:
            new_werb = chr(32 + (ord(list1[i]) - derot))
        else:    
            new_werb = chr(((ord(list1[i]) - derot - 1040) % 32) + 1040)        
        list2.append(new_werb)
    else:
        new_werb = list1[i]
        list2.append(new_werb)
        
result = ''.join(list2)
print(result)    


# ## Дешифрование текста на английском языке

# In[20]:


# деШифр англ

derot = 25
string = "Sgd fqzrr hr zkvzxr fqddmdq nm sgd nsgdq rhcd ne sgd edmbd."
list1 = [string[i] for i in range(len(string))]

list2 = []         
for i in range (len(list1)):
    if (ord(list1[i]) >= 65 and
        ord(list1[i]) <= 90):## Шифрование текста на английском языке
        if ord(list1[i]) - 90 - derot < 0:
            new_werb = chr(26 + (ord(list1[i]) - derot))
        else:
            new_werb = chr(((ord(list1[i]) - derot - 65) % 26) + 65)
        list2.append(new_werb)
        
    elif (ord(list1[i]) >= 97 and
        ord(list1[i]) <= 122):
        if ord(list1[i]) - 97 - derot < 0:
            new_werb = chr(26 + (ord(list1[i]) - derot))
        else:    
            new_werb = chr(((ord(list1[i]) - derot - 97) % 26) + 97)        
        list2.append(new_werb)
    else:
        new_werb = list1[i]
        list2.append(new_werb)
        
result = ''.join(list2)
print(result)    


# ## Дешифрование текста на английском языке с неизвестным ключом

# In[21]:


# деШифр англ с неизвестным ключом

for k in range(26):
    derot = k
    string = "Hawnj pk swhg xabkna ukq nqj."
    list1 = [string[i] for i in range(len(string))]
    
    list2 = []         
    for i in range (len(list1)):
        if (ord(list1[i]) >= 65 and
            ord(list1[i]) <= 90):
            
            if ord(list1[i]) - 90 - derot < 0:
                new_werb = chr(26 + (ord(list1[i]) - derot))
            else:
                new_werb = chr(((ord(list1[i]) - derot - 65) % 26) + 65)
            list2.append(new_werb)
            
        elif (ord(list1[i]) >= 97 and
            ord(list1[i]) <= 122):
            if ord(list1[i]) - 97 - derot < 0:
                new_werb = chr(26 + (ord(list1[i]) - derot))
            else:    
                new_werb = chr(((ord(list1[i]) - derot - 97) % 26) + 97)        
            list2.append(new_werb)
        else:
            new_werb = list1[i]
            list2.append(new_werb)
            
    result = ''.join(list2)
    print(k, result)    


# ## Шифрование модифицированным шифром цезаря

# Ключ шифрования принимается равным длине слова.

# In[24]:


# шифр англ в зависимости от длины слова

string = input()
words = string.split() # Строка разбивается на слова
list3 = []

for word in range(len(words)): # Цикл для работы со словами
    rot = 0
    for j in range(len(words[word])): # Цикл для вычисления сдвига в зависимости от длины слова
        if (ord(words[word][j]) >= 65 and  ord(words[word][j]) <= 90) or (ord(words[word][j]) >= 97 and  ord(words[word][j]) <= 122):
            rot += 1                  # Накапливаем 1 за каждую букву, за другие символы не накапливаем
    
    letters = [words[word][i] for i in range(len(words[word]))] # Разбиваем слово на буквы для дальнейшего пробразования
    
    list2 = []         
    for i in range (len(letters)): # Цикл по изменению каждой буквы в соотвествии с ключом
        if (ord(letters[i]) >= 65 and # Проверка по строчным буквам
            ord(letters[i]) <= 90):
            new_werb = chr(((ord(letters[i]) + rot - 65) % 26) + 65)
            list2.append(new_werb) # Добавляем букву в список
            
        elif (ord(letters[i]) >= 97 and # Проверка по заглавным буквам
            ord(letters[i]) <= 122):
            new_werb = chr(((ord(letters[i]) + rot - 97) % 26) + 97)        
            list2.append(new_werb) # Добавляем букву в список
        else: # Другие символы ее меняем
            new_werb = letters[i]
            list2.append(new_werb)
            
    if word != len(words) - 1: # К каждому слову, кроме последнего добавляем пробел
        list2.append(' ')        
    result = ''.join(list2) # склеиваем буквы в слово
    list3.append(result)  # добавялем слово в итоговый список
    
itog_result = ''.join(list3) # Склеиваем слова во фразу
print(itog_result)

