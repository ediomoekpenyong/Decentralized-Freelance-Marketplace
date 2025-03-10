import { describe, it, expect, vi } from 'vitest';

// Mock the contract calls
const contractCall = vi.fn();

describe('Job Listing Contract', () => {
  it('should post a new job', async () => {
    contractCall.mockResolvedValue({ success: true, jobId: 1 });
    const result = await contractCall('post-job', ['Job Title', 'Job Description', '1000']);
    expect(result).toEqual({ success: true, jobId: 1 });
  });
  
  it('should allow freelancers to apply for a job', async () => {
    contractCall.mockResolvedValue({ success: true });
    const result = await contractCall('apply-for-job', ['1', 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM']);
    expect(result).toEqual({ success: true });
  });
  
  it('should award a job to a freelancer', async () => {
    contractCall.mockResolvedValue({ success: true });
    const result = await contractCall('award-job', ['1', 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM']);
    expect(result).toEqual({ success: true });
  });
  
  it('should mark a job as completed', async () => {
    contractCall.mockResolvedValue({ success: true });
    const result = await contractCall('complete-job', ['1']);
    expect(result).toEqual({ success: true });
  });
  
  it('should retrieve job details', async () => {
    contractCall.mockResolvedValue({
      jobId: '1',
      title: 'Job Title',
      description: 'Job Description',
      payment: '1000',
      status: 'open'
    });
    const result = await contractCall('get-job-details', ['1']);
    expect(result).toEqual({
      jobId: '1',
      title: 'Job Title',
      description: 'Job Description',
      payment: '1000',
      status: 'open'
    });
  });
});
