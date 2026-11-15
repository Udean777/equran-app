import { compareRecitation, warmHafalanApi } from "./hafalan-api";

jest.mock("expo/fetch", () => ({ fetch: jest.fn() }));
jest.mock("expo-file-system", () => ({
  File: class {
    constructor(uri: string) {
      this.uri = uri;
    }
    uri: string;
  },
}));

const mockedFetch = jest.requireMock<{ fetch: jest.Mock }>("expo/fetch").fetch;

const COMPARE_PAYLOAD = {
  score: 88,
  passed: true,
  threshold: 75,
  transcribed: "بِسْمِ اللَّهِ",
  target: "بِسْمِ اللَّهِ",
  cer: 2,
  word_errors: [],
  duration_ms: 1200,
};

const response = (json: unknown, status = 200) => ({
  ok: status >= 200 && status < 300,
  status,
  json: async () => json,
});

const abortError = () => {
  const cause = new Error("Aborted");
  cause.name = "AbortError";
  return cause;
};

describe("hafalan api", () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it("retries once when the first attempt fails with a network error", async () => {
    mockedFetch
      .mockRejectedValueOnce(new Error("Network request failed"))
      .mockResolvedValueOnce(response(COMPARE_PAYLOAD));

    const result = await compareRecitation({
      audioUri: "file:///setoran.m4a",
      targetText: "بِسْمِ اللَّهِ",
    });

    expect(mockedFetch).toHaveBeenCalledTimes(2);
    expect(result.ok).toBe(true);
    if (result.ok) expect(result.value.score).toBe(88);
  });

  it("returns a network error after both attempts fail", async () => {
    mockedFetch.mockRejectedValue(new Error("Network request failed"));

    const result = await compareRecitation({
      audioUri: "file:///setoran.m4a",
      targetText: "بِسْمِ اللَّهِ",
    });

    expect(mockedFetch).toHaveBeenCalledTimes(2);
    expect(result.ok).toBe(false);
    if (!result.ok) expect(result.error.code).toBe("network");
  });

  it("does not retry a timeout", async () => {
    mockedFetch.mockRejectedValueOnce(abortError());

    const result = await compareRecitation({
      audioUri: "file:///setoran.m4a",
      targetText: "بِسْمِ اللَّهِ",
    });

    expect(mockedFetch).toHaveBeenCalledTimes(1);
    expect(result.ok).toBe(false);
    if (!result.ok) expect(result.error.code).toBe("timeout");
  });

  it("does not retry a server error", async () => {
    mockedFetch.mockResolvedValueOnce(response({ detail: "boom" }, 500));

    const result = await compareRecitation({
      audioUri: "file:///setoran.m4a",
      targetText: "بِسْمِ اللَّهِ",
    });

    expect(mockedFetch).toHaveBeenCalledTimes(1);
    expect(result.ok).toBe(false);
    if (!result.ok) expect(result.error.code).toBe("server");
  });

  it("returns a parse error when the payload does not match the schema", async () => {
    mockedFetch.mockResolvedValueOnce(response({ score: "high" }));

    const result = await compareRecitation({
      audioUri: "file:///setoran.m4a",
      targetText: "بِسْمِ اللَّهِ",
    });

    expect(result.ok).toBe(false);
    if (!result.ok) expect(result.error.code).toBe("parse");
  });

  it("wakes the API without throwing when the service is down", async () => {
    mockedFetch.mockRejectedValueOnce(new Error("Network request failed"));

    const result = await warmHafalanApi();

    expect(mockedFetch).toHaveBeenCalledTimes(1);
    expect(result.ok).toBe(false);
    if (!result.ok) expect(result.error.code).toBe("network");
  });

  it("reports a non-ok health response", async () => {
    mockedFetch.mockResolvedValueOnce(response({}, 503));

    const result = await warmHafalanApi();

    expect(result.ok).toBe(false);
    if (!result.ok) expect(result.error.code).toBe("server");
  });
});
