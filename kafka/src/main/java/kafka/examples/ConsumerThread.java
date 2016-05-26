package kafka.examples;

import java.io.IOException;

import kafka.consumer.ConsumerIterator;
import kafka.consumer.KafkaStream;
import kafka.message.MessageAndMetadata;

public class ConsumerThread implements Runnable {
	
	private KafkaStream<byte[], byte[]> stream;
	private int threadNumber;
	private String task;
	
	private static final String STOP_KAFKA="STOP-KAFKA";
	
	public ConsumerThread(KafkaStream<byte[], byte[]> stream, int threadNumber, String task) {
		this.stream = stream;
		this.threadNumber = threadNumber;
		this.task = task;
	}
	
	public void run() {
		ConsumerIterator<byte[], byte[]> iter = stream.iterator();
		while(iter.hasNext()) {
			MessageAndMetadata<byte[], byte[]> messageAndMetadata = iter.next();
			String message = new String(messageAndMetadata.message());
			System.out.println(threadNumber + ": Message from " + messageAndMetadata.topic() + " Topic: " + message);
			
			if(message.equals(STOP_KAFKA))
				break;
			
			// Execute Bash Task
			try {
				String[] cmd = new String[]{task, message};
				Runtime.getRuntime().exec(cmd);
			} catch (IOException e) {
				System.out.println("Error executing Bash Task: " + task);
				e.printStackTrace();
			}
		}
		System.out.println("Shutting Down Thread: " + Thread.currentThread().getName() + ": " + threadNumber);
	}

}
