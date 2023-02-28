#code to find the sum of elememts in an array

#creating an empty array
list =[]
#to set the number of elements
n = int(input("Enter the number of elements : "))

#to allow input of elements
for i in range(0,n):
    elements =int(input())
    list.append(elements)
    #print out the array 
    print(list)
#using the inbuilt sum function to get sum of the array elements
list_sum =sum(list)
print("sum is: ",list_sum)
