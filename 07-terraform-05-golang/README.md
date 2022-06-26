# Домашнее задание к занятию "7.5. Основы golang"

С `golang` в рамках курса, мы будем работать не много, поэтому можно использовать любой IDE. 
Но рекомендуем ознакомиться с [GoLand](https://www.jetbrains.com/ru-ru/go/).  

## Задача 1. Установите golang.
1. Воспользуйтесь инструкций с официального сайта: [https://golang.org/](https://golang.org/).
2. Так же для тестирования кода можно использовать песочницу: [https://play.golang.org/](https://play.golang.org/).

## Задача 2. Знакомство с gotour.
У Golang есть обучающая интерактивная консоль [https://tour.golang.org/](https://tour.golang.org/). 
Рекомендуется изучить максимальное количество примеров. В консоли уже написан необходимый код, 
осталось только с ним ознакомиться и поэкспериментировать как написано в инструкции в левой части экрана.  

## Задача 3. Написание кода. 
Цель этого задания закрепить знания о базовом синтаксисе языка. Можно использовать редактор кода 
на своем компьютере, либо использовать песочницу: [https://play.golang.org/](https://play.golang.org/).

1. Напишите программу для перевода метров в футы (1 фут = 0.3048 метр). Можно запросить исходные данные у пользователя, а можно статически задать в коде.
    Для взаимодействия с пользователем можно использовать функцию `Scanf`:
    > 
	> Добавил в листинг функции Константу `FOOT` и изменил алгоритм расчета показателя `output`
	> 
  
	```golang
    package main
    
    import "fmt"
    
    func main() {
        fmt.Print("Enter a number: ")
        var input float64
        const FOOT = 0.3048 //Константа для перевода Метров в Футы
        fmt.Scanf("%f", &input)
    
        output := input * FOOT
    
        fmt.Println(output)    
    }
    ```
 
1. Напишите программу, которая найдет наименьший элемент в любом заданном списке, например:
    ```
    x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}
    ```
> 
```golang
package main

import "fmt"

func main() {
	x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17}
	// Вывод: 9
	fmt.Println(minItems(x))
}

func minItems(x []int) int {  
   min := x[0]  
   for _, val := range x {  
      if min > val {  
         min = val  
      }  
   }  
   return min  
}
```

1. Напишите программу, которая выводит числа от 1 до 100, которые делятся на 3. То есть `(3, 6, 9, …)`.
В виде решения ссылку на код или сам код. 

> 
```golang
package main

import (  
   "fmt"  
   "strconv"
)

func main() {  
   fmt.Print(divide3())  
}  
func divide3() string {  
   r := ""  
   for i := 1; i <= 100; i++ {  
      if (i % 3) == 0 {  
         r += strconv.Itoa(i) + ", "  
      }  
   }  
   return r  
}

```
> 

## Задача 4. Протестировать код (не обязательно).

Создайте тесты для функций из предыдущего задания. 

> Тест программ:
> 
```golang
package main  
  
import (  
   "testing"  
)  
// Тест программы, которая найдет наименьший элемент в любом заданном списке

func TestMinItems(t *testing.T) {  
   x := []int{-2, 800, 4, -800}  
   minX0 := -800  
   minX1 := minItems(x)  
   if minX1 != minX0 {  
      t.Errorf("got %d, wanted %d", minX0, minX1)  
   }  
}


//Тест программы, которая выводит числа от 1 до 100, которые делятся на 3

func TestDivide3(t *testing.T) {  
   var test1 string = "3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36, 39, 42, 45, 48, 51, 54, 57, 60, 63, 66, 69, 72, 75, 78, 81, 84, 87, 90, 93, 96, 99, "  
   var div3 string  
   div3 = divide3()  
   if div3 != test1 {  
      t.Errorf("got %q, wanted %q", test1, div3)  
   }  
}


```

> Результат выполнения `go test` :
> 
```golang

GOROOT=/usr/lib/go-1.18 #gosetup
GOPATH=/home/arcdm/go #gosetup
/usr/lib/go-1.18/bin/go test -json ./...
=== RUN   TestMinItems
--- PASS: TestMinItems (0.00s)
=== RUN   TestDivide3
--- PASS: TestDivide3 (0.00s)
PASS
ok  	awesomeProject1	0.001s

Process finished with the exit code 0

```
---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---

