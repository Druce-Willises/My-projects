#!/usr/bin/env python
# coding: utf-8

# # Числовая угадайка

# In[58]:


# Импорт библиотек

import random
import math

def func_is_valid_rightside(num):       # Функция для проверки введенной строки(число от 1 до 1000)
    try:
        num = int(num)
    except:
        print('Неверный формат ввода. Введите число от 1 до 1000', right_side)
        return False
    if num < 1 or num > 1000:
        print('Число вне диапазона. Введите число от 1 до 1000', right_side)
        return False
    return True

def func_is_valid_number(num):          # Функция для проверки введенной строки(число от 1 до правой границы диапазона)
    try:
        num = int(num)
    except:
        print('Неверный формат ввода. Введите число от 1 до', right_side)
        return False
    if num < 0 or num > 100:
        print('Число вне диапазона. Введите число от 1 до', right_side)
        return False
    return True

def func_is_valid_yes_no(bool):          # Функция для проверки формата ввода "Да" / "Нет"
    if bool == 'да' or bool == 'нет':
        return True
    else:
        print('Неверный формат ввода. Введите "да" или "нет" без кавычек')
        return False

while True:
        
    while True:
        right_side = input('Введите правую границу диапазона, в котором хотите искать число. (Количество попыток будет скорректировано). ')
        if func_is_valid_rightside(right_side) == False:
            continue
        else:
            break
            
    right_side = int(right_side)                        # Превращаем правую границу в число
    initial_trys = math.ceil(math.log(right_side, 2))   # Высчитываем количество попыток, исходя из правой границы
    print('Число попыток:', initial_trys)
    hidden_number = random.randint(1, right_side)       # Загадываем рандомное число в диапзоне от 1 до правой границы
    #print(hidden_number)
    trys = initial_trys                                 # Присваиваем счетчику количество попыток для работы след. цикла while
        
    while trys != 0:
        while True:             # Цикл, повторяющий input(), пока юзер не введет число в нужном формате
            user_number = input('Введите предполагаемое число: ',)
            if func_is_valid_number(user_number) == False: # Вызов функции проверки формата введенной строки. 
                continue                                   # повторяем цикл, если невереный формат
            else:
                break                                      # прерываем цикл и идём дальше, если число в верном формате
                
        user_number = int(user_number)    
        
        if user_number == hidden_number:                   # Сравнение введенного чила с загаданным
            print('Поздравляю, вы угадали! Это было число', user_number)
            print('У вас получилось с', initial_trys - trys + 1, 'попытки')
            break            
        elif user_number < hidden_number:
            print('Загаданное число БОЛЬШЕ введённого')
            print('Осталось попыток:', trys-1)
        elif user_number > hidden_number:
            print('Загаданное число МЕНЬШЕ введённого.')
            print('Осталось попыток:', trys-1)        
        trys -= 1                                           # Уменьшение счетчика, согласно числу оставшихся попыток

    print('Попробовать еще раз? "да" / "нет"', sep='\n')
    
    while True: # Цикл, повторяющий input(), пока юзер не введет ответ "Да" / "Нет" в нужном формате
        try_again = input()
        if func_is_valid_yes_no(try_again) == False:        # Вызов функции проверки формата введенной строки. 
            continue                                        # повторяем цикл, если формат невереный
        else:        
            break                                           # прерываем цикл и идём дальше, если формат верный
                    
    if try_again == 'нет':                                  # прерываем внешний цикл, если пользователь ввёл "нет"
        print('Спасибо за игру! Приходите ещё')
        break
    else:        
        continue

