import { HttpRequest } from '../model/HttpRequest'

@Observed
export class RequestViewModel {
  @Track requestInfo: HttpRequest = new HttpRequest()
}