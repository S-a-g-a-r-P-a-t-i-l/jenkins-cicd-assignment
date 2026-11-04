package com.example;

public class App {

    public static int add(int a, int b) {
        return a + b;
    }

    public static void main(String[] args) {
        System.out.println("Hello Jenkins! Automatic Build Test");

        int result = add(10, 20);

        System.out.println("Addition Result: " + result);
    }
}
