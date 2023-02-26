#!/usr/bin/env python
# coding: utf-8

# # Генератор безопасных паролей

# In[11]:


import random
            

def is_valid_number(num):                # Функция для проверки формата введеного номера
    try:
        number = int(num)
        return True
    except:
        return False
    
def is_valid_yes_no(bool):                # Функция для проверки формата введеного булевого значения "да/нет" 
    if bool == 'да' or bool == 'нет':
        return True
    else:
        return False
    
digits = '0123456789'
lower_words = ''.join([chr(i) for i in range(ord('a'), ord('z')+1)]) # строка со строчными буквами a - z
upper_words = ''.join([chr(i) for i in range(ord('A'), ord('Z')+1)]) # строка с заглавными буквами A - Z
punctuations = '!#$%&*+-=?@^_'
exclude_symbols = 'il1Lo0O'

while True: # Цикл до тех пока пользователь не введёт строку в необходимом формате
    password_quantity = input('Какое количество паролей необходимо?  ')
    if is_valid_number(password_quantity) == True:
        break
        
while True: # Цикл до тех пока пользователь не введёт строку в необходимом формате
    password_len = input('Какая необходима длина запрашиваемого пароля?  ')
    if is_valid_number(password_len) == True:
        break
        
while True: # Цикл до тех пока пользователь не введёт строку в необходимом формате
    needing_digits = input('Использовать цифры для генерации пароля?  ')
    if is_valid_yes_no(needing_digits) == True:
        break
        
while True: # Цикл до тех пока пользователь не введёт строку в необходимом формате
    needing_lower_words = input('Использовать строчные буквы для генерации пароля?  ')
    if is_valid_yes_no(needing_lower_words) == True:
        break
        
while True: # Цикл до тех пока пользователь не введёт строку в необходимом формате
    needing_upper_words = input('Использовать заглавные буквы для генерации пароля?  ')
    if is_valid_yes_no(needing_upper_words) == True:
        break
        
while True: # Цикл до тех пока пользователь не введёт строку в необходимом формате
    needing_punctuations = input('Использовать пунктуационных знаки для генерации пароля?  ')
    if is_valid_yes_no(needing_punctuations) == True:
        break
        
while True: # Цикл до тех пока пользователь не введёт строку в необходимом формате
    needing_exclude_symbols = input('Исключить символы "il1Lo0O" при генерации пароля?  ')
    if is_valid_yes_no(needing_exclude_symbols) == True:
        break
        
all_passwords = []  

for i in range(int(password_quantity)):   # Цикл для перебора нескольких паролей 
    for j in range(int(password_len)):    # Цикл для перебора символов внутри одного пароля
        avaliable_symbols = []            # Список, куда будут включены все необходимые символы
        
        if needing_digits == 'да':                    # условие для включения цифр в пароль
            avaliable_symbols.extend(digits)
        if needing_lower_words == 'да':               # условие для включения цифр в пароль
            avaliable_symbols.extend(lower_words)
        if needing_upper_words == 'да':               # условие для строчных букв в пароль
            avaliable_symbols.extend(upper_words)
        if needing_punctuations == 'да':              # условие для заглавных букв в пароль
            avaliable_symbols.extend(punctuations)
        if needing_exclude_symbols == 'да':           # условие для исключения похожих с виду символов из доступных символов для пароля
            
            for k in range(len(exclude_symbols)):     # цикл по удалении этих символов из списка для формирования пароля
                avaliable_symbols.remove(exclude_symbols[k])
   
        password = ''.join(random.sample(avaliable_symbols, int(password_len)))
        
    all_passwords.append(password)

print()
print('Ваши сгенерированные пароли:', *all_passwords, sep='\n')

