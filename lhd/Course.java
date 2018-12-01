import java.util.ArrayList;
import java.util.Scanner;

public class Course {
	private String name;
	private ArrayList<component> evaluations = new ArrayList<component>() ;
	
	public static final int LETTER_GRADE_A= 85;
	public static final int LETTER_GRADE_A_MIN= 80;
	public static final int LETTER_GRADE_B_PL= 75;
	public static final int LETTER_GRADE_B= 70;
	public static final int LETTER_GRADE_B_MIN= 65;
	public static final int LETTER_GRADE_C_PL= 60;
	public static final int LETTER_GRADE_C= 55;
	public static final int LETTER_GRADE_D= 50;
	
	public ArrayList<component> fill(){
		Scanner scanner = new Scanner(System.in);
		
		int loop = 0;
		while (loop==0 || loop == 1) {
			
			if (loop==0) {
				System.out.println("Welcome to the Grade Grinder \n Please enter the name of the first component");
				loop=1;
			}
			if (loop ==1) {
				System.out.println("What is the next component?");
			}
				String componentName = scanner.next();  
			
			int valid = 0;
			int componentWorth = 0;
			while(valid == 0) {			
				System.out.println("What is it's worth?");
				componentWorth = scanner.nextInt();
				if(componentWorth > 100) {
					//the input can not be anything other than 1-5, so reset the loop if it isn't
					System.out.println("This assignment can't be worth more than 100...");
					continue;
					}
				if(componentWorth < 1) {
					System.out.println("Why is this assignment not worth anything?");
					continue;
				}
				valid = 1;
			}
			
			valid = 0;
			int componentGrade = 0;
			while(valid ==0) {
				System.out.println("What grade did you get (enter a percentage)?");
				componentGrade = scanner.nextInt();
				if(componentGrade > 100) {
					//the input can not be anything other than 1-5, so reset the loop if it isn't
					System.out.println("You got more than 100? Congrats, but we dont count bonus marks");
					continue;
					}
				if(componentGrade < 0) {
					System.out.println("How did you fail the assignment so badly?? You can't really be int he negatives");
					continue;
				}
				valid = 1;
			}
			
			evaluations.add(new component(componentName, componentWorth, componentGrade));
			
			int loopc = 0;
			while (loopc==0){
				System.out.println("Are there any more components? \n Please enter Y or N");
				String cont = scanner.next();
				if (cont.equals("Y") || cont.equals("y") ) {
					loopc=1;
					continue;
				}else if(cont.equals("N") || cont.equals("n")) {
					loopc=1;
					loop=-1;
				} else {
					System.out.println("Please try again");	
				}
			
			}
			
		}
	
		scanner.close();
		return evaluations;
    }
	
	public Course (String name, ArrayList<component> evaluations) {
		this.name = name;
		this.evaluations = evaluations;
	}
	
	public String getNameCourse() {
		return this.name;
	}
	public ArrayList<component> getComponentsCourse() {
		return this.evaluations;
	}
	
	public static void main (String[] args) {
		
		ArrayList<component> yo = getComponentsCourse();
	}
	
}
