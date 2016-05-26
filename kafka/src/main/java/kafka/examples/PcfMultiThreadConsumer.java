package kafka.examples;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

import kafka.consumer.Consumer;
import kafka.consumer.ConsumerConfig;
import kafka.consumer.KafkaStream;
import kafka.javaapi.consumer.ConsumerConnector;

public class PcfMultiThreadConsumer {
	
	private ExecutorService executor;
	private final ConsumerConnector consumer;
	private String groupId;
	private HashMap<String, Integer> topics;
	private HashMap<String, String> tasks; 
	private Integer threadCount;
	
	private static final String GROUP_ID = "group.id";
	private static final String TOPICS = "topics";
	private static final String TASKS = "tasks";
	
	public PcfMultiThreadConsumer(String pcfProp, String zookeeper) {
		threadCount = 0;
		topics = new HashMap<String, Integer>();
		tasks = new HashMap<String, String>();
		if(loadProp(pcfProp)) {
			Properties properties = new Properties();
	        properties.put("zookeeper.connect", zookeeper);
	        properties.put("group.id", groupId);
	        properties.put("zookeeper.session.timeout.ms", "500");
	        properties.put("zookeeper.sync.time.ms", "250");
	        properties.put("auto.commit.interval.ms", "1000");
	
	        consumer = Consumer.createJavaConsumerConnector(new ConsumerConfig(properties));
		}
		else
			consumer = null;
	}
	
	public void initialize() {
		
	}
	
	public void openStreams() {
		Map<String, List<KafkaStream<byte[], byte[]>>> consumerStreams = consumer.createMessageStreams(topics);
		
		executor = Executors.newFixedThreadPool(threadCount);
		
		for(String topic: topics.keySet()) {
			List<KafkaStream<byte[], byte[]>> streams = consumerStreams.get(topic);
			
			int threadNumber = 0;
			for(final KafkaStream<byte[], byte[]> stream: streams) {
				executor.submit(new ConsumerThread(stream, threadNumber, tasks.get(topic)));
				threadNumber++;
			}
		}
		
		try {
			executor.shutdown();
			executor.awaitTermination(100L, TimeUnit.DAYS);
		}
		catch (InterruptedException ie) {

        }
		finally {
	        if (consumer != null) {
	            consumer.shutdown();
	        }
	        if (executor != null) {
	            executor.shutdown();
	        }
		}
	}
	
	public boolean loadProp(String prop) {
		Properties properties = new Properties();
		InputStream is = null;
		String topicsStr = null;
		String tasksStr = null;
		
		try {
			is = new FileInputStream(prop);
			properties.load(is);
			
			groupId = properties.getProperty(GROUP_ID);
			topicsStr = properties.getProperty(TOPICS);
			tasksStr = properties.getProperty(TASKS);
		}
		catch(IOException e) {
			System.out.println("Error reading the properties file: " + prop);
			e.printStackTrace();
			return false;
		}
		finally {
			if(is != null) {
				try {
					is.close();
				}
				catch(IOException e) {
					e.printStackTrace();
				}
			}
		}
		
		List<String> topicList = Arrays.asList(topicsStr.split(","));
		List<String> taskList = Arrays.asList(tasksStr.split(","));
		if(topicList.size() != taskList.size()) {
			System.out.println("Count of topics and tasks are not equal!!!");
			return false;
		}
		
		for(int i = 0; i < topicList.size(); i++) {
			String topic = topicList.get(i);
			String task = taskList.get(i);
			String[] topicThreads = topic.split("\\.");
			if(topic.indexOf('.') == -1 || topicThreads[1] == null || topicThreads[1].equals("0")) {
				System.out.println("Wrong topic or topic value: " + topic);
				return false;
			}
			try {
				Integer threads = Integer.parseInt(topicThreads[1]);
				topics.put(topicThreads[0], threads);
				tasks.put(topicThreads[0], task);
				threadCount += threads;
			}
			catch(NumberFormatException e) {
				System.out.println("Wrong topic value for topic: " + topicThreads[0]);
				e.printStackTrace();
				return false;
			}
		}
		
		return true;
	}
	
	public static void main(String[] args) {
		String prop;
		String zookeeper;
		
		if(args.length != 2) {
			System.out.println("USAGE: PcfMultiThreadConsumer <pcf.properties> <zookeeper.connect>");
			return;
		}
		
		prop = args[0];
		zookeeper = args[1];
		PcfMultiThreadConsumer pcfConsumer = new PcfMultiThreadConsumer(prop, zookeeper);
		if(pcfConsumer.consumer == null)
			return;
		
		pcfConsumer.openStreams();
		
	}
}
