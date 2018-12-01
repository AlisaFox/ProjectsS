
public class component {
	private String name;
	private int worth;
	private int grade;
	
	public component (String name, int worth, int grade) {
		this.name = name;
		this.worth = worth;
		this.grade = grade;
	}
	
	public String getName() {
		return this.name;
	}
	public int getWorth() {
		return this.worth;
	}
	public int getGrade() {
		return this.grade;
	}
	
	public String toString() {
		String info = "";
		info += this.name + " is worth " + this.worth + "% of the course, you got a grade of " +this.grade;
		return info;
	}
}
