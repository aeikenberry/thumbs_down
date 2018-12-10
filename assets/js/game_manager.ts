class ThumbsDownManager {
  public started: boolean = false
  public inCountdown: boolean = false
  public startTime?: Date
  public users: any[] = []

  public startCountdown() {
    this.inCountdown = true
  }

  public start(users: any[]) {
    this.users = users
    this.inCountdown = false
    this.started = true
    this.startTime = new Date()
  }

  public userInGame(user: any): boolean {
    return this.users
      .filter((u) => u.name === user.name)
      .length > 0
  }

  private isGameOver(): boolean {
    return this.users
      .filter((user) => user.hasThumbDown === true)
      .length <= 1
  }
}
