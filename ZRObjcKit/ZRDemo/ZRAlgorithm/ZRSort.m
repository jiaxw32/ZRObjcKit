//
//  ZRSort.m
//  ZRObjcKit
//
//  Created by jiaxw-mac on 2018/2/23.
//  Copyright © 2018年 jiaxw. All rights reserved.
//

#import "ZRSort.h"

#pragma mark - 冒泡排序

void bubbleSort(int arr[], int length){
    if (length < 2) {
        return;
    }
    int temp;
    for (int i = 0; i < length - 1; i++) {
        for (int j = 0; j < length - 1 - i; j++) {
            if (arr[j] > arr[j + 1]) {
                temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
        }
    }
}

#pragma mark - 快速排序

/**
 快速排序分区
 
 @param arr 输入数据
 @param low 最小索引
 @param high 最大索引
 @return 返回分区索引值
 */
static int partition(int arr[], int low, int high){
    int pivot = arr[low];
    int temp;
    while (true) {
        while (arr[high] >= pivot && high > low) {
            high--;
        }
        while (arr[low] < pivot && high > low) {
            low++;
        }
        
        if (low < high) {
            temp = arr[low];
            arr[low] = arr[high];
            arr[high] = temp;
        } else {
            return high;
        }
    }
}


/**
 快速排序
 
 @param arr 输入数据
 @param low 最小索引
 @param high 最大索引
 */
void quickSort(int arr[], int low, int high){
    if (low < high) {
        int index = partition(arr, low, high);
        quickSort(arr, low ,index);
        quickSort(arr, index + 1, high);
    }
}

@implementation ZRSort

+ (void)bubbleSort{
    int arr[10];
    for (int i = 0; i < 10; i++) {
        arr[i] = arc4random() % 100;
    }
    
    printf("original data:\t");
    for (int i = 0; i < 10; i ++) {
        printf("%i\t", arr[i]);
    }
    printf("\n");
    
    bubbleSort(arr, 10);
    printf("bubble sorted data:\t");
    for (int i = 0; i < 10; i ++) {
        printf("%i\t", arr[i]);
    }
    printf("\n");
}

+ (void)quickSort{
    int arr[10];
    for (int i = 0; i < 10; i++) {
        arr[i] = arc4random() % 100;
    }
    
    printf("original data:\t");
    for (int i = 0; i < 10; i ++) {
        printf("%i\t", arr[i]);
    }
    printf("\n");

    quickSort(arr, 0, 10 - 1);
    printf("quick sorted data:\t");
    for (int i = 0; i < 10; i ++) {
        printf("%i\t", arr[i]);
    }
    printf("\n");
}

@end
